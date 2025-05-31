#!/bin/bash
# Este código se ejecutará para crear las PGS de los fenotipos concretos seleccionados mediante PRS-CS

# Cargamos los módulos necesarios
module load plink/v2.0

# Y definimos los nombres de archivos base
muestra="TFM"
path="path"


# Para ello, usaremos un bucle for mediante el cuál iteraremos para cada uno de los fenotipos seleccionados su PGS asociado mediante la función --score del paquete plink2

for fenotipo in SZ BD MDD ADHD; do 
    plink2 \
        --bfile "${sample}_OK" \
        --score "$path/${fenotipo}.weightsall" 2 4 6 cols=+scoresums \
        --out "${muestra}.${fenotipo}"
done

