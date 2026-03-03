
# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

**Evidencia de Gobernanza y Explotación Analítica**

## I. OBJETIVO DEL ANEXO

El presente anexo documenta la evidencia cuantitativa generada mediante el notebook:

EDA_GOVERNANCE_INBOX_STG.ipynb

Su propósito es validar estructural y analíticamente el pipeline completo:

RAW → STG → DW → SEM → BI

Este análisis complementa la fase de gobernanza ejecutada sobre datos RAW y formaliza la verificación empírica de la consolidación dimensional y estabilidad de la capa semántica (dw_sem).

---

## II. MARCO METODOLÓGICO

### A. Nivel de análisis

El estudio se ejecuta exclusivamente sobre:

1) Tablas STG (staging mensual)  
2) Esquema dw (modelo dimensional persistente)  
3) Esquema dw_sem (contrato analítico estable)  

No se modifican datos ni estructuras.  
El análisis es estrictamente descriptivo y validatorio.

### B. Principios técnicos aplicados

1) Reproducibilidad tras reconstrucción automática (docker compose down -v).  
2) Separación formal de capas (stg, dw, dw_sem).  
3) Integración dimensión–hecho mediante claves sustitutas (*_sk).  
4) Cálculo temporal exclusivamente vía dw.dim_fecha.  
5) Eliminación de dependencias implícitas entre bloques del notebook.  

---

## III. RESULTADOS Y ANÁLISIS

### A. Continuidad temporal en STG

**Fig. {A}.1** presenta el volumen mensual de registros staging (LIC y OC).

Interpretación:  
Se observa continuidad estructural del período analizado, sin interrupciones técnicas.  
La simetría entre dominios indica estabilidad en el proceso de ingestión.

---

### B. Consolidación temporal en SEM

**Fig. {A}.2** muestra la distribución mensual consolidada en la capa semántica.

Interpretación:  
La consolidación dimensional preserva la cobertura temporal.  
No se introducen sesgos inter-mensuales durante la integración.

---

### C. Integridad dimensión–hecho

**Fig. {A}.3** y **Fig. {A}.4** muestran los 10 organismos con mayor actividad (LIC y OC respectivamente).

Interpretación técnica:  
La correcta integración vía organismo_sk confirma integridad referencial.  
No se detectan claves huérfanas.

---

### D. Reducción estructural STG → SEM

**Tabla {A}.1** resume la relación entre volumen STG y volumen consolidado SEM.

Hallazgo principal:

Total_registros_SEM < Total_registros_STG

Interpretación:  
La reducción responde a depuración estructural y consolidación dimensional.  
No representa pérdida arbitraria de información.

---

### E. Relación inter-dominio LIC–OC

**Fig. {A}.5** presenta el ratio mensual:

ratio_lic_oc = n_lic / n_oc

Interpretación:  
Se observa estabilidad relativa entre dominios.  
El pipeline no genera distorsiones inter-dominio.

---

### F. Escalabilidad física del modelo

**Fig. {A}.6** compara el tamaño físico por esquema.

Interpretación:  
El modelo dimensional optimiza almacenamiento.  
La capa semántica no introduce crecimiento desproporcionado.

---

## IV. TRAZABILIDAD ENTRE EVIDENCIA E INFORME

| Evidencia | Referencia |
|-----------|------------|
| Fig. {A}.1 | Continuidad STG |
| Fig. {A}.2 | Consolidación SEM |
| Fig. {A}.3–{A}.4 | Integridad dimensión–hecho |
| Tabla {A}.1 | Reducción estructural |
| Fig. {A}.5 | Ratio LIC/OC |
| Fig. {A}.6 | Escalabilidad física |

---

## V. LIMITACIONES

1) Análisis descriptivo, no inferencial.  
2) No se evalúan atributos textuales en profundidad.  
3) Dependencia del rango temporal disponible.  

---

## VI. CONCLUSIÓN FORMAL

La evidencia presentada en el Anexo {A} demuestra que:

1) La arquitectura implementada es estructuralmente coherente.  
2) La consolidación dimensional es consistente.  
3) La capa semántica es estable y reproducible.  
4) El modelo es físicamente escalable.  
5) El contrato analítico soporta explotación BI defendible académicamente.

