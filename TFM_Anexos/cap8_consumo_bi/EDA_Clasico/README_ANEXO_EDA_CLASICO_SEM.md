
# ANEXO — EDA Clásico sobre Capa Semántica (SEM)

## ChileCompra Data Platform — Trabajo Fin de Máster (UCM)

---

## 1. Propósito del Anexo

El presente documento acompaña al notebook:

ANEXO_EDA_Clasico_SEM_dw_sem_v1_base.ipynb

y constituye la evidencia narrativa e interpretativa del Análisis Exploratorio de Datos (EDA) clásico ejecutado sobre la capa semántica (`dw_sem`) del Data Warehouse.

Este anexo no sustituye el EDA principal del proyecto —realizado sobre RAW con enfoque de Data Governance, Data Quality Profiling y Matching Diagnosis— sino que lo complementa mediante una descripción estadística estándar del universo analítico final consumido por Power BI.

En consecuencia, el análisis aquí documentado:

- Se ejecuta exclusivamente sobre `dw_sem`.
- No modifica datos ni estructuras.
- No realiza imputación ni limpieza.
- Segmenta obligatoriamente por `moneda_norm`.
- Produce evidencia reproducible (CSV y PNG).

---

## 2. Marco Metodológico

El proyecto adopta un enfoque dual de análisis exploratorio:

1. **EDA estructural sobre RAW** → orientado a gobernanza, continuidad mensual, duplicidad, consistencia de fuente y trazabilidad.
2. **EDA clásico sobre SEM** → orientado a describir distribución, completitud, concentración y dinámica temporal del dataset gobernado final.

La separación es metodológicamente coherente:

- RAW permite auditar la fuente.
- SEM representa el contrato analítico estable consumido por BI.

Este anexo, por tanto, describe el comportamiento estadístico del universo analítico consolidado.

---

## 3. Magnitud Global del Universo Analítico

El análisis de magnitud evidencia:

- Volumen total de licitaciones (LIC) y órdenes de compra (OC).
- Distribución por `moneda_norm`.
- Diversidad institucional (organismos distintos).
- Diversidad de proveedores.
- Diversidad de productos ONU.

La visualización comparativa LIC vs OC por moneda confirma:

- Existencia de dominios con mayor peso relativo.
- Coherencia estructural entre ambos procesos administrativos.
- Ausencia de asimetrías anómalas entre dominios.

Desde una perspectiva arquitectónica, la capa SEM preserva la magnitud estructural consolidada tras el proceso ETL.

---

## 4. Completitud y Calidad Descriptiva

El análisis Top 25 de columnas con mayor porcentaje de valores nulos muestra:

- Variables con completitud casi total (campos clave del modelo dimensional).
- Variables con mayor dispersión o uso contextual.
- Diferencias naturales entre LIC y OC derivadas del diseño operativo del sistema ChileCompra.

No se detectan patrones de nulos estructurales que comprometan:

- Integridad referencial.
- Capacidad analítica básica.
- Consistencia del modelo dimensional.

Este resultado confirma que la capa SEM mantiene calidad descriptiva adecuada para explotación BI.

---

## 5. Distribución Estadística de Montos

El análisis de percentiles (P50, P90, P95, P99 y máximo) por `moneda_norm` evidencia:

- Distribuciones asimétricas positivas.
- Presencia de colas largas.
- Diferencias estructurales entre monedas.
- Existencia de valores extremos significativos.

Los boxplots y histogramas muestran claramente:

- Concentración de operaciones en tramos inferiores.
- Aparición de outliers de magnitud considerable.
- No normalidad de la distribución (esperable en contratación pública).

Estos resultados justifican:

- Uso de percentiles para análisis robusto.
- Cautela en interpretación de promedios.
- Segmentación obligatoria por moneda.

---

## 6. Outliers y Transparencia

El listado de Top 20 montos por dominio permite:

- Identificar operaciones de alta magnitud.
- Asociarlas a organismos y periodos específicos.
- Garantizar transparencia en el análisis.

No se aplican técnicas de eliminación ni ajuste.

La existencia de valores extremos es consistente con:

- Compras públicas de alto impacto.
- Procesos excepcionales.
- Proyectos institucionales de gran escala.

Su presencia no representa anomalía técnica, sino característica estructural del dominio.

---

## 7. Concentración Institucional

El análisis de concentración (Top 10 organismos y curva acumulada) revela:

- Participación desigual en la distribución del gasto.
- Existencia de organismos con peso estructural dominante.
- Curvas acumuladas que evidencian concentración parcial del presupuesto.

Desde una perspectiva económica, esto es consistente con:

- Instituciones con mayor capacidad presupuestaria.
- Concentración sectorial.
- Diferencias funcionales entre organismos.

Este hallazgo fundamenta análisis posteriores de concentración y diseño de KPIs institucionales.

---

## 8. Dinámica Temporal

La evolución mensual de:

- Número de operaciones.
- Montos totales por moneda.

permite observar:

- Continuidad temporal del sistema.
- Estabilidad relativa entre LIC y OC.
- Variaciones mensuales coherentes con dinámica presupuestaria.

No se detectan quiebres estructurales abruptos en la serie temporal consolidada, lo que confirma:

- Correcta integración con `dim_fecha`.
- Consistencia del proceso ETL.
- Estabilidad del modelo dimensional.

---

## 9. Implicancias para la Capa BI

Los resultados del EDA clásico sobre SEM fundamentan directamente:

- Segmentación obligatoria por `moneda_norm`.
- Construcción de KPIs robustos basados en percentiles.
- Interpretación contextual de outliers.
- Evaluación de concentración institucional.
- Validación previa a publicación de dashboards.

La explotación BI se apoya en un dataset previamente validado estadísticamente.

---

## 10. Conclusión Técnica

El EDA clásico sobre la capa semántica confirma que:

1. El universo analítico final es consistente.
2. La consolidación dimensional preserva estructura y magnitud.
3. Las distribuciones presentan características esperables para contratación pública.
4. La concentración institucional es estructural, no accidental.
5. La dinámica temporal es coherente con el proceso administrativo.

En conjunto, este anexo aporta la evidencia descriptiva estándar esperada en un Trabajo Fin de Máster, complementando la gobernanza estructural desarrollada sobre RAW y fortaleciendo la trazabilidad completa del pipeline:

RAW → STG → DW → SEM → BI

---
