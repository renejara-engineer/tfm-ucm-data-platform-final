# Capítulo 8 — Consumo Analítico y Evidencia BI

---

## 1. Objetivo del capítulo

El presente capítulo valida el consumo analítico del Data Warehouse consolidado, demostrando coherencia numérica y semántica entre:

- El modelo dimensional (Cap. 5),
- Las vistas semánticas (`dw_sem`),
- El contrato analítico definido en SQL,
- Y las medidas implementadas en Power BI.

Su propósito no es exponer visualizaciones, sino verificar que la capa BI es consecuencia directa y controlada del diseño estructural previo.

---

## 2. Rol dentro de la arquitectura global

Este capítulo opera exclusivamente sobre estructuras ya consolidadas.

No transforma datos.  
No redefine métricas.  
No altera el modelo dimensional.  
No interviene en el pipeline ETL.

Su función es cerrar el ciclo arquitectónico iniciado en:

Arquitectura → Modelado → Gobierno → Operación → Consumo Validado

Se conecta directamente con:

- Capítulo 5 — Modelo Dimensional  
- Capítulo 6 — Gobierno de Datos  
- Capítulo 7 — Operación y Orquestación  

---

## 3. Estructura del capítulo

El capítulo se organiza en cuatro bloques de evidencia.

---

### 3.1 Evidencia Pre-BI — Contrato Analítico SQL-first

Ruta:  
`evidencia_preBI/fase5_BI/`

Notebooks vigentes:

- `TFM_Fase5_BI_00_Check_Entorno.ipynb`
- `TFM_Fase5_BI_01_Contrato_KPIs_SQL.ipynb`

Propósito:

- Definir KPIs directamente en SQL antes de su implementación en BI.
- Establecer el contrato analítico como fuente primaria de verdad.
- Evitar que DAX se convierta en generador autónomo de métricas.

Nota de nomenclatura:

La denominación “Fase5_BI” corresponde a la nomenclatura interna del ciclo de desarrollo.  
En la estructura académica final del TFM, este bloque forma parte integral del Capítulo 8.

Versiones históricas:

Las versiones iterativas del contrato analítico se conservan en:

`evidencia_preBI/fase5_BI/archivos/`

con fines exclusivos de trazabilidad histórica y no forman parte del flujo oficial de evidencia.

La versión vigente del contrato analítico es:

`TFM_Fase5_BI_01_Contrato_KPIs_SQL.ipynb`

---

### 3.2 Auditoría de Coherencia Numérica DW vs BI

Ruta:  
`auditoria_bi/Coherencia_numerica_DW_vs_BI/`

Notebooks:

- `DT_TEND_y_DT_SECT/Evidencia_DT_TEND_DT_SECT_v4.ipynb`
- `LIC/LIC_Evidencia_BI_vs_SQL_v9.ipynb`
- `OC/OC_Evidencia_BI_vs_SQL_v4.ipynb`
- `RECON/RECON_Evidencia_BI_vs_SQL_v6.ipynb`

Propósito:

- Verificar que los resultados obtenidos en Power BI coinciden con los cálculos SQL ejecutados directamente sobre el DW.
- Confirmar coherencia por dominio funcional (LIC, OC, RECON y dimensiones técnicas).
- Mitigar riesgo de divergencia semántica entre herramienta analítica y base estructural.

La numeración (v4, v6, v9) corresponde a iteraciones internas de desarrollo; los archivos presentes en este anexo constituyen el snapshot final consolidado.

---

### 3.3 Trazabilidad Analítica

Ruta:  
`auditoria_bi/Trazabilidad/`

Incluye documentación que mapea explícitamente:

DW → Vista Semántica → Medida BI

Propósito:

- Evitar opacidad en la construcción de indicadores.
- Documentar origen y dependencia estructural de cada métrica.
- Garantizar reproducibilidad analítica.

---

### 3.4 EDA Clásico sobre Vistas Semánticas

Ruta:  
`EDA_Clasico/`

Notebook:

- `ANEXO_EDA_Clasico_SEM_dw_sem_v1_base.ipynb`

Función:

- Realizar análisis exploratorio clásico sobre estructuras semánticas consolidadas.
- Proveer evidencia estadística independiente de Power BI.
- Complementar validación descriptiva del sistema analítico.

---

## 4. Principios metodológicos aplicados

El capítulo se rige por los siguientes principios estructurales:

- SQL como fuente primaria de verdad.
- BI como capa de evidencia, no de redefinición.
- Separación estricta entre dominios LIC y OC.
- No conversión de moneda.
- No creación de métricas fuera del contrato analítico.
- Validación cruzada obligatoria DW ↔ BI.

---

## 5. Límites del capítulo

Este capítulo no:

- Introduce transformaciones nuevas.
- Modifica el modelo dimensional.
- Altera procesos ETL.
- Reestructura el Data Warehouse.

Su función es exclusivamente validatoria y probatoria.

---

## 6. Cierre estructural

El Capítulo 8 demuestra que el sistema analítico no depende de supuestos visuales ni de interpretaciones arbitrarias.

Las métricas expuestas en BI son reproducibles, trazables y consistentes con el modelo dimensional previamente definido.

Con ello se completa el ciclo arquitectónico del TFM, garantizando coherencia técnica y defendibilidad académica.
