# Fase 5 — Modelo Analítico y Catálogo de KPIs  

## 1. Propósito del documento

Este documento define **el modelo analítico oficial** de la Fase 5 del TFM  
*ChileCompra Data Platform*.

Su objetivo es:

- Consolidar **todas las variables y KPIs** discutidas y analizadas.
- Establecer el **grano analítico oficial** por dominio.
- Definir KPIs **antes** de cualquier implementación BI.
- Evitar métricas improvisadas o engañosas.
- Servir como **contrato analítico** entre el Data Warehouse y Power BI.
- Ser **citable y defendible** en la memoria del TFM.

Este documento **no implementa KPIs**: los define formalmente.

---

## 2. Principios analíticos rectores

Las definiciones aquí contenidas se rigen por los siguientes principios:

1. No se inventan datos.
2. No se agregan métricas fuera del DW.
3. El grano manda (no se agregan niveles incorrectos).
4. BI no corrige errores de modelado.
5. Toda métrica debe ser reproducible en SQL.
6. Se prioriza fidelidad al negocio sobre comodidad técnica.

---

## 3. Fuentes de datos consideradas

Las métricas se construyen exclusivamente desde:

- `dw.fact_licitaciones`
- `dw.fact_ordenes_compra`
- Dimensiones:
  - `dw.dim_fecha`
  - `dw.dim_organismo`
  - `dw.dim_proveedor`
  - `dw.dim_producto_onu`

Campos provenientes originalmente de `stg_lic_YYYY_MM` y `stg_oc_YYYY_MM`  
solo se consideran válidos si están correctamente integrados al DW.

---

## 4. Grano analítico oficial

El grano define **qué se puede y qué no se puede medir**.

### 4.1 Grano analítico del dominio Licitaciones (LIC)

**Grano oficial:**

Licitación × Proveedor × Producto × Periodo

**Justificación:**

- Una licitación puede adjudicar a múltiples proveedores.
- Un proveedor puede adjudicarse solo parte de los productos.
- Agregar a nivel licitación “plana” oculta la realidad del negocio.
- Este grano es indispensable para KPIs por proveedor y producto.

---

### 4.2 Grano analítico del dominio Órdenes de Compra (OC)

**Grano oficial:**

Orden de Compra × Producto × Proveedor × Periodo

**Justificación:**

- Las OC se materializan por proveedor y producto.
- El monto real ejecutado vive en OC, no en LIC.
- Es el nivel correcto para tiempos, ejecución y materialización.

---

### 4.3 Relación analítica entre LIC y OC

- La relación es **temporal y legal**, no estrictamente 1:1 por periodo.
- Puede existir desfase entre adjudicación (LIC) y ejecución (OC).
- La cuadratura total puede darse **en el tiempo**, no en un solo mes.

Este punto es **crítico para evitar análisis engañosos**.

---

## 5. Variables analíticas base

### 5.1 Variables clave del dominio LIC

| Variable               | Descripción                                   |
| ---------------------- | --------------------------------------------- |
| monto_estimado         | Monto estimado de la licitación               |
| monto_adjudicado       | Monto adjudicado                              |
| cantidad_items         | Número de ítems                               |
| cantidad_oferentes     | Número de oferentes                           |
| estado_licitacion      | Estado administrativo                         |
| tipo_adquisicion       | Tipo de proceso                               |
| moneda                 | Moneda                                        |
| periodo                | Periodo analítico                             |
| proveedor              | Proveedor adjudicado                          |
| producto_onu           | Producto ONU                                  |
| cantidad_reclamos      | Número de reclamos asociados                  |

**Nota crítica:**  
`cantidad_reclamos` fue discutida explícitamente como variable relevante  
para análisis de riesgo y calidad del proceso.

---

### 5.2 Variables clave del dominio OC

| Variable            | Descripción                    |
| ------------------- | ------------------------------ |
| monto_total         | Monto total de la OC           |
| cantidad_items      | Cantidad de líneas             |
| fecha_creacion      | Fecha de creación              |
| fecha_aceptacion    | Fecha de aceptación            |
| proveedor           | Proveedor                      |
| producto_onu        | Producto ONU                   |
| estado_oc           | Estado de la OC                |
| tipo_oc             | Tipo de OC                     |
| periodo             | Periodo analítico              |

---

## 6. Catálogo amplio de KPIs (no priorizado)

Este catálogo representa **el máximo abanico considerado**.  
La priorización se realiza posteriormente.

---

### 6.1 KPIs del dominio Licitaciones (LIC)

| KPI                                   | Descripción                              |
| ------------------------------------- | ---------------------------------------- |
| Monto estimado LIC                    | Suma de montos estimados                 |
| Monto adjudicado LIC                  | Suma de montos adjudicados               |
| Porcentaje de adjudicación            | monto_adjudicado / monto_estimado        |
| Número de licitaciones                | Conteo de licitaciones                   |
| Número de proveedores adjudicados     | Proveedores distintos                    |
| Número de productos por licitación    | Diversidad de productos                  |
| Número promedio de oferentes          | Media de oferentes                       |
| Porcentaje de licitaciones desiertas  | Según estado                             |
| Total de reclamos LIC                 | Suma de reclamos                         |
| Reclamos promedio por licitación      | Indicador de calidad                     |
| Concentración de proveedor (Pareto)   | Riesgo de dependencia                    |

---

### 6.2 KPIs del dominio Órdenes de Compra (OC)

| KPI                              | Descripción                     |
| -------------------------------- | ------------------------------- |
| Monto total OC                   | Suma ejecutada                  |
| Número de OC                     | Cantidad de órdenes             |
| Monto promedio OC                | Monto medio                     |
| Tiempo creación a aceptación     | SLA operativo                   |
| Número de productos por OC       | Complejidad                     |
| Porcentaje de OC por proveedor   | Dependencia                     |
| Porcentaje de OC por producto    | Concentración                   |

---

### 6.3 KPIs cruzados LIC–OC

| KPI                                   | Descripción                    |
| ------------------------------------- | ------------------------------ |
| Porcentaje LIC materializado en OC    | Ejecución real                 |
| Diferencia monetaria LIC vs OC        | Gap financiero                 |
| Desfase promedio en días              | Tiempo de ejecución            |
| Número de OC por licitación           | Fragmentación                  |
| Proveedores con mayor gap             | Riesgo operativo               |

---

## 7. Plantilla obligatoria de definición formal de KPIs

Cada KPI priorizado deberá documentarse con la siguiente estructura:

| Campo               | Definición                    |
| ------------------- | ----------------------------- |
| Nombre del KPI      | Nombre oficial                |
| Dominio             | LIC / OC / Cruzado            |
| Definición negocio  | Qué mide                      |
| Fórmula lógica      | Expresión conceptual          |
| Grano               | Nivel correcto                |
| Tabla DW            | Fuente                        |
| Campos utilizados   | Columnas involucradas         |
| Observaciones       | Advertencias o limitaciones   |

Esta tabla es **obligatoria** para cada KPI implementado.

---

## 8. KPIs descartados y transparencia académica

Algunos KPIs pueden descartarse por:

- Falta de calidad de datos
- Ambigüedad semántica
- Riesgo de mala interpretación

Estos casos deben quedar **explícitamente documentados**.

---

## 9. Relación con validación analítica y BI

- Este documento alimenta directamente:
  - `04_criterios_validacion_analitica.md`
  - `05_modelo_bi_powerbi.md`
- Ningún KPI puede aparecer en BI si no está definido aquí.
- BI **no redefine KPIs**, solo los representa.

---

## 10. Alcance y límites del documento

Incluido:

- Definición conceptual completa
- Grano analítico y variables
- Catálogo amplio de KPIs
- Consideraciones de negocio

Excluido:

- SQL de implementación
- DAX
- Automatización

---

## 11. Estado del documento

- Estado: **Congelado (base oficial)**
- Cambios futuros:
  - Solo mediante nueva versión
  - Con justificación explícita

---

## Declaración final

Este documento constituye la **fuente de verdad analítica** del proyecto.  
Ninguna métrica, visualización o conclusión puede contradecirlo sin una  
actualización formal y versionada del mismo.
