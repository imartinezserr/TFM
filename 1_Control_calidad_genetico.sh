#!/bin/bash

# CONTROL DE CALIDAD GENÉTICO

# Una vez descargados y anotados los datos genéticos imputados a través del servidor de imputación de Michigan, se realizará el control de calidad específico para variantes 
# genéticas e individuos

# Cargamos los módulos necesarios
module load plink/v1.9
module load R

# Y definimos los nombres de archivos base

## Datos preimputados
muestrapi="TFM_preimp"   

## Datos imputados  
muestrai="TFM_imp"   

## Datos imputados tras QC      
muestraqc="TFM_QC"    
 
## Datos listos para PGS/pPGS    
muestraok="TFM_OK"         

# CONTROL DE CALIDAD DE VARIANTES GENÉTICAS

## Filtro por frecuencia alélica mínima (MAF)
plink --bfile "$muestrai" --maf 0.01 --write-snplist --make-bed --out "$muestraqc"

## Equilibrio Hardy-Weinberg (HWE)
plink --bfile "$muestraqc" --hwe 1e-6 --make-bed --out "$muestraqc"

## Filtro por tasa de genotipado (GENO)
plink --bfile "$muestraqc" --geno 0.1 --make-bed --out "$muestraqc"

# CONTROL DE CALIDAD DE INDIVIDUOS

## Pruning para heterocigosidad y análisis de parentesco
plink --bfile "$muestraqc" --write-snplist --make-bed --out "$muestraqc"
plink --bfile "$muestraqc" --extract "$muestraqc.snplist" --indep-pairwise 200 50 0.25 --out "$muestraqc"

## Heterocigosidad
plink --bfile "$muestraqc" --extract "$muestraqc.prune.in" --het --out heteroz

Rscript - <<EOF
library(data.table)
dat <- fread("heteroz.het")
valid <- dat[F <= mean(F) + 3 * sd(F) & F >= mean(F) - 3 * sd(F)]
invalid <- dat[!(F <= mean(F) + 3 * sd(F) & F >= mean(F) - 3 * sd(F))]
fwrite(valid[, .(FID, IID)], "heteroz.valid.sample", sep = "\t")
fwrite(invalid[, .(FID, IID)], "heteroz.invalid.sample", sep = "\t")
EOF

## Filtro por missingness individual
plink --bfile "$muestraqc" --mind 0.1 --make-just-fam --out missingness

## Parentesco

plink --bfile "$muestraqc" --extract "$muestraqc.prune.in" --genome --make-just-fam --out relatedness_nocutoff

# VERIFICACIONES CON DATOS PREIMPUTADOS

## Análisis de escalado multidimensional (MDS)
plink --bfile "$muestrapi" --cluster --out "${muestrapi}_mds"

## Verificación del sexo cromosómico
Rscript - <<EOF
library(data.table)
bim <- fread("${muestrapi}.bim")
bim[V1 == "23", V1 := "X"]
bim[V1 == "24", V1 := "Y"]
fwrite(bim, "XY.bim", sep = " ")
EOF

plink --bfile "$muestrapi" --extract XY.bim --check-sex --out sex

Rscript - <<EOF
library(data.table)
sex <- fread("sex.sexcheck")
fwrite(sex[STATUS == "OK", .(FID, IID)], "sex.valid", sep = "\t")
fwrite(sex[STATUS == "PROBLEM", .(IID)], "sex_excluded", sep = "\t")
EOF

# CONSTRUCCIÓN DE ARCHIVO FINAL PARA PGS/pPGS

## Filtrar por heterocigosidad y missingness
plink --bfile "$muestraqc" --keep heteroz.valid.sample --make-bed --out TEMP1
plink --bfile TEMP1 --keep missingness.fam --make-bed --out TEMP2

## Filtrar por sexo correcto
plink --bfile TEMP3 --keep sex.valid --make-bed --out "$muestraok"

## Limpiar archivos temporales
rm TEMP*
