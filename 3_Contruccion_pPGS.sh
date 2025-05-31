#!/bin/bash
# Este código se ejecutará para crear las pPGS de las vías biológicas seleccionadas mediante PRSet

# En primer lugar, adaptaremos al estructura del GWAS procesado por PRS-CS para que PRSet lo reconozca. Dado que PRSet necesita una columna de p-valor, la generaremos en       # formato dummy, ya que únicamente es problema de formatado y luego no será necesario utilizarla. En este caso, nos centramos en el GWAS de esquizofrenia.

# Y definimos los nombres de archivos base
muestra="TFM"
path="path"

awk 'BEGIN{OFS="\t"} NR==1{$(NF+1)="P"} NR>1{$(NF+1)="1e-5"} 1' \
    $path/SZ.weightsall > SZ.weightsall.pval.txt

# Y generaremos un bucle for mediante el cuál iteraremos para cada una de las vías biológicas seleccionadas su pPGS asociado mediante la función PRSet del paquete PRSice

for set in GOBP_SYNAPTIC_TRANSMISSION_DOPAMINERGIC \
           GOBP_SYNAPTIC_TRANSMISSION_GABAERGIC \
           GOBP_SYNAPTIC_TRANSMISSION_GLUTAMATERGIC \
           HP_NEUROINFLAMMATION
do
    echo "Procesando $set..."
    
    Rscript PRSice.R \
        --prsice PRSice \
        --base SZ.weightsall.pval.txt \
        --target $muestra \
        --no-regression \
        --thread 1 \
        --gtf Homo_sapiens.GRCh37.87.gtf \
        --msigdb ${set}.v2024.1.Hs.gmt \
        --multi-plot 10 \
        --stat WEIGHT \
        --pvalue P \
        --beta \
        --no-clump \
        --score std \
        --bar-levels 1 \
        --lower 0 \
        --upper 1 \
        --out PRSet_BD_${set}
done



