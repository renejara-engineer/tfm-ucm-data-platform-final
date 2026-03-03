# Modelo Semántico de Explotación Analítica

## (Power BI sobre Data Warehouse ChileCompra)

------------------------------------------------------------------------

## 0. Marco conceptual y jerarquía documental

El presente documento define el **modelo semántico de explotación
analítica** implementado en Power BI sobre el Data Warehouse del
proyecto ChileCompra Data Platform.

Este documento:

- No redefine arquitectura.
- No modifica el Data Warehouse.
- No introduce transformaciones adicionales.
- No corrige datos.

El estado técnico consolidado del sistema se encuentra declarado en:

`arquitectura/estado_oficial_pipeline_dw.md`

En caso de discrepancia, prevalece dicho documento.

El modelo BI constituye una **capa de consumo y evidencia analítica**,
subordinada al Data Warehouse.

------------------------------------------------------------------------

## 1. Objetivo del modelo BI

El objetivo del modelo semántico en Power BI es:

- Representar fielmente la información contenida en el DW.
- Permitir análisis descriptivo y exploratorio.
- Garantizar coherencia numérica con consultas SQL.
- Mantener trazabilidad completa DW → BI.

El BI no tiene rol correctivo ni transformador.

------------------------------------------------------------------------

## 2. Condición de entrada obligatoria

La capa BI solo puede construirse si:

- El Data Warehouse se encuentra validado.
- No existen inconsistencias estructurales abiertas.
- Las métricas base están definidas en el modelo analítico DW.
- El contrato analítico está formalmente documentado.

El BI depende completamente de la estabilidad del DW.

------------------------------------------------------------------------

## 3. Principio fundamental: BI no correctivo

La capa BI:

- No corrige nulos.
- No elimina atípicos.
- No completa información faltante.
- No reinterpreta reglas de negocio.

Toda visualización refleja exactamente el estado del Data Warehouse.

Si existe un valor atípico en DW, este debe ser visible en BI.

El BI cumple función descriptiva y probatoria.

------------------------------------------------------------------------

## 4. Alcance temporal representado

El modelo BI representa exclusivamente los periodos incorporados al DW
según el estado oficial del pipeline.

Periodos excluidos por decisión técnica documentada no aparecen en BI
por definición metodológica.

Su ausencia es deliberada.

------------------------------------------------------------------------

## 5. Gate BI-1: Vista técnica de validación

El modelo incorpora una vista técnica de reconciliación denominada Gate
BI-1.

Su finalidad es:

- Verificar conexión DW → BI.
- Validar totales sin filtros analíticos.
- Detectar valores atípicos visibles.
- Confirmar integridad estructural.

No constituye dashboard de consumo final.

------------------------------------------------------------------------

## 6. Hechos y dimensiones expuestas en BI

### Hechos

- `dw.fact_licitaciones`
- `dw.fact_ordenes_compra`

### Dimensiones

- `dw.dim_fecha`
- `dw.dim_organismo`
- `dw.dim_proveedor`
- `dw.dim_producto_onu`

Las relaciones reflejan exactamente el modelo relacional del DW.

------------------------------------------------------------------------

## 7. Grano analítico

### Licitaciones

Grano:

Licitación × Proveedor × Producto ONU × Periodo

Fuente:

`dw.fact_licitaciones`

### Órdenes de Compra

Grano:

Orden de Compra × Proveedor × Producto ONU × Periodo

Fuente:

`dw.fact_ordenes_compra`

No se permite mezclar LIC y OC sin contexto explícito.

------------------------------------------------------------------------

## 8. Modelo de relaciones

Reglas obligatorias:

- Cardinalidad Many-to-One.
- Dirección de filtro: Single.
- No se permiten relaciones many-to-many.
- No se permiten relaciones ambiguas.
- No se permiten caminos alternativos.

El modelo semántico replica la estructura DW sin reinterpretaciones.

------------------------------------------------------------------------

## 9. Métricas base permitidas

### Licitaciones (LIC)

- Conteo de licitaciones
- Monto adjudicado
- Monto estimado
- Cantidad de oferentes
- Cantidad de ítems
- Cantidad de reclamos

### Órdenes de Compra (OC)

- Conteo de órdenes
- Monto total OC
- Cantidad de ítems
- Cantidad de productos distintos

Todas las métricas deben existir previamente en el DW.

------------------------------------------------------------------------

## 10. KPIs derivados permitidos

Los KPIs derivados se construyen únicamente a partir de métricas base
válidas.

Ejemplos:

- Promedio de monto por licitación
- Promedio de monto por orden
- Participación porcentual por proveedor
- Concentración por producto ONU
- Distribución de gasto por organismo

No se permiten:

- KPIs que mezclen LIC y OC sin dimensión temporal explícita.
- KPIs que corrijan valores faltantes.
- KPIs que supongan cuadratura obligatoria entre tablas.

------------------------------------------------------------------------

## 11. Estructura mínima de dashboards

El modelo contempla como mínimo:

- Dashboard Licitaciones
- Dashboard Órdenes de Compra
- Dashboard descriptivo de análisis cruzado

El análisis cruzado es descriptivo, no normativo.

------------------------------------------------------------------------

## 12. Reglas visuales obligatorias

- Mostrar siempre periodo.
- Mostrar unidad monetaria explícita.
- No ocultar valores cero.
- No suavizar outliers.
- No aplicar filtros implícitos.
- Documentar cada página del dashboard.

------------------------------------------------------------------------

## 13. Validación obligatoria

Antes de considerar válido el modelo BI:

- Los totales deben reconciliar con SQL.
- Los resultados deben coincidir con el DW.
- No deben existir filtros ocultos.
- Cada métrica debe trazarse hasta su definición SQL.

La trazabilidad DW → DAX → Visual debe ser demostrable.

------------------------------------------------------------------------

## 14. Alcance metodológico

Power BI constituye:

- Capa de explotación analítica.
- Capa de evidencia.
- Capa de validación externa del DW.

No constituye:

- Sistema transaccional.
- Motor de transformación.
- Mecanismo de corrección.

------------------------------------------------------------------------

## 15. Declaración final

Power BI es una capa de consumo y evidencia.\
La validez analítica depende exclusivamente de la consistencia del Data
Warehouse.

Si el dato no es válido en el DW, no es válido en BI.
