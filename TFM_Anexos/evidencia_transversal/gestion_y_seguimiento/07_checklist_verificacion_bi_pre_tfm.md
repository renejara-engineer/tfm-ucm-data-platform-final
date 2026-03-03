# Checklist de Verificación BI — Pre TFM

TFM: ChileCompra Data Platform  
Universidad Complutense de Madrid (UCM)

---

## 1. Propósito del checklist

Este checklist tiene por objetivo **verificar y documentar** que la
capa de **Business Intelligence (BI)** se encuentra correctamente
implementada **antes de su uso en la memoria final del TFM**.

El checklist **no ejecuta acciones técnicas**, sino que:

- verifica coherencia,
- deja evidencia de validación,
- documenta el cierre formal ya realizado de la Fase 5,
- valida que BI represente fielmente el Data Warehouse.

---

## 2. Condiciones de entrada obligatorias

Antes de aplicar este checklist, deben cumplirse todas las siguientes
condiciones:

- [x] Fase 5 (Data Warehouse) **cerrada**
- [x] Gate 3 (DW Analítico) **aprobado**
- [x] Contrato analítico BI-0 **cerrado**
- [x] Gate BI-1 (vista técnica de reconciliación) **revisado**
- [x] No existen incidencias abiertas en `docs/05_project_log.md`

Si alguna condición no se cumple → **BI NO VÁLIDO PARA TFM**.

---

## 3. Alcance del checklist

- Periodos validados: `2024-09` a `2025-10`
  - `2024-09` se considera **periodo piloto de referencia**
- Periodos excluidos (NO-OP, documentados):
  - `2025-01`
  - `2025-03`

Este checklist **no cubre**:

- periodos excluidos como NO-OP,
- automatización futura,
- optimización visual avanzada.

La ausencia de los periodos NO-OP **no constituye un error**.

---

## 4. Verificación de conexión DW → BI

- [x] La conexión BI utiliza exclusivamente el Data Warehouse validado.
- [x] No existen fuentes externas adicionales.
- [x] No existen tablas importadas manualmente.
- [x] El modelo BI refleja exactamente el esquema del DW.

---

## 5. Verificación del modelo semántico

- [x] Hechos y dimensiones coinciden con el DW.
- [x] No existen relaciones many-to-many.
- [x] Cardinalidades correctas.
- [x] Dirección de filtro única.
- [x] No existen caminos alternativos.

---

## 6. Verificación de métricas y KPIs

- [x] Todas las métricas existen previamente en el DW.
- [x] No se redefinen KPIs en BI.
- [x] KPIs alineados con `docs/fase5/03_modelo_analitico_kpis.md`.
- [x] No se imputan valores faltantes.
- [x] No se suavizan outliers.

---

## 7. Verificación temporal y filtros

- [x] Los periodos están visibles en filtros y/o segmentadores.
- [x] El periodo `2024-09` es visible como periodo piloto de referencia.
- [x] Los periodos adicionales (`2024-10` a `2025-10`) están disponibles.
- [x] La ausencia de periodos NO-OP (`2025-01`, `2025-03`) no se marca como error.
- [x] Se preservan valores atípicos (Año NULL / Año 2029) en vistas técnicas.

---

## 8. Verificación de dashboards

- [x] Dashboards separados para LIC y OC.
- [x] Dashboard LIC vs OC es **descriptivo**, no normativo.
- [x] No se mezclan métricas sin contexto temporal explícito.
- [x] Se muestran unidades y moneda.

---

## 9. Verificación de validación analítica

- [x] Totales reconciliados con SQL.
- [x] Métricas coinciden con resultados del DW.
- [x] No existen filtros ocultos.
- [x] Evidencias registradas en `docs/05_project_log.md`.

---

## 10. Resultado final

- [x] BI validado para inclusión en memoria TFM.

---

## Estado del documento

- Estado: **Congelado**
- Fase: **5 (cerrada)**

---

## Declaración final

Este checklist certifica que la capa BI cumple un rol **descriptivo y
probatorio**, sin introducir correcciones ni reinterpretaciones sobre
el Data Warehouse.
