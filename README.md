# TFM

Repositorio con los scripts utilizados en el análisis del TFM: *Evaluación de perfiles poligénicos basados en diagnósticos psiquiátricos y vías biológicas para predecir psicosis de inicio precoz en la adolescencia*

## Contenido

- `1_Control_calidad_genetico.sh`
-     Script en bash para el control de calidad genético de los datos de genotipado después de la imputación.

- `2_Construccion_PGS.sh`
-     Script en bash para la construcción de puntuaciones poligénicas (PGS, por sus siglas en inglés) mediante `plink2`.

- `3_Contruccion_pPGS.sh`
-     Script en bash para la construcción de PGS para vías biológicas (pPGS) adaptado para usar como referencia los datos de GWAS preprocesados por el algoritmo PRS-CS.

- `4_Analisis_estadistico_R.Rmd`
-     Notebook en RMarkdown que incluye:
  - Figuras de resultados preliminares
  - Análisis exploratorio de datos
  - Análisis descriptivo: demográfico y clínico
  - Análisis univariable: regresión logística para cada PGS y pPGS por separado + validación cruzada de 10-fold
  - Análisis multivariable: regresión logística con selección de LASSO + validación cruzada de 10-fold
  - Evaluación del rendimiento predictivo

## Requisitos

- R ≥ 4.0 
- PLINK v1.9 y v2.0
- PRSice-2

## Paquetes de R utilizados

### Base de datos

- `readxl`
- `dplyr`
- `data.table`
- `tidyverse`

### Análisis exploratorio

- `visdat`
- `corrplot`
- `metan`
- `purrr`
- `factoextra`
- `DataExplorer`
- `GGally`

### Análisis descriptivo

- `gtsummary`
- `apaTables`
- `rcompanion`
- `broom`
- `epiDisplay`

### Análisis univariable y multivariable

- `lmerTest`
- `emmeans`
- `nlme`
- `MuMIn`
- `lme4`
- `FDRestimation`
- `pbkrtest`
- `FactoMineR`
- `caret`
- `pROC`
- `ResourceSelection`
- `glmnet`
- `pscl`
- `car`
- `smss`
- `ROSE`
- `MLeval`

### Tablas y gráficos

- `knitr`
- `kableExtra`
- `patchwork`
- `lattice`
- `ggplot2`
- `grid`
- `gridExtra`
- `cowplot`
- `ganttrify`
- `VennDiagram`
- `RColorBrewer`

## Entorno de trabajo

El código ha sido desarrollado en:

- **Sistema operativo:** Linux (procesamiento de datos de genotipado y construcción de PGS y pPGS) y Windows (RStudio, análisis exploratorio y estadístico).
- **Formato de salidas:** Informe en PDF generado a partir de `.Rmd`.

---

## Nota

Código publicado con fines académicos.
