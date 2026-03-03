
# Gate 3 — Decisiones Arquitectónicas

## 1. Propósito del documento

Este documento formaliza las **decisiones arquitectónicas adoptadas en Gate 3 (DW Analítico)**, a partir de los hallazgos identificados al iniciar la Fase 5.

Su objetivo es:

- Dejar evidencia explícita de las **opciones evaluadas**
- Justificar la **opción finalmente seleccionada**
- Explicar el impacto de cada alternativa en:
  - el modelo DW,
  - los KPIs,
  - la capa BI,
  - y la coherencia con el negocio ChileCompra

Este documento es complementario a:

- `docs/hallazgos/.../01_modelado_vs_negocio.md`
- `docs/fase5/00_continuidad_tecnica_gate3.md`

---

## 2. Contexto de la decisión (Gate 3)

Al iniciar Gate 3 se constató que:

- El Data Warehouse estaba correctamente definido a nivel estructural (dimensiones + hechos).
- Sin embargo, **no existía aún una carga analítica real** que permitiese:
  - validar KPIs,
  - evaluar coherencia negocio–modelo,
  - habilitar Power BI sin riesgo de distorsión.

El conflicto principal detectado fue la **relación entre Licitaciones (LIC), Órdenes de Compra (OC), Proveedores y Productos**, particularmente en escenarios de adjudicación múltiple.

---

## 3. Opciones arquitectónicas evaluadas

### 3.1 Opción A — Hecho único LIC + OC (DESCARTADA)

**Descripción:**

- Unificar LIC y OC en una sola tabla de hechos.
- Resolver la relación mediante columnas opcionales.

**Ventajas aparentes:**

- Simplicidad inicial.
- Menor número de tablas.

**Problemas críticos:**

- Mezcla eventos de naturaleza distinta (demanda vs ejecución).
- Dificulta KPIs temporales (LIC vs OC).
- Genera nulos estructurales.
- Introduce ambigüedad semántica en BI.

**Conclusión:**  
❌ Descartada por violar principios de modelado dimensional y trazabilidad analítica.

---

### 3.2 Opción B — Hechos separados LIC y OC + relación analítica (ELEGIDA)

**Descripción:**

- Mantener:
  - `fact_licitaciones`
  - `fact_ordenes_compra`
- Definir granos explícitos:
  - LIC = licitación × proveedor × producto
  - OC = orden × producto
- Relacionar LIC–OC de forma **analítica**, no forzada por FK directa.

**Ventajas:**

- Refleja fielmente el negocio ChileCompra.
- Soporta adjudicación múltiple.
- Permite KPIs correctos por:
  - proveedor,
  - producto,
  - organismo,
  - periodo.
- Evita inflación de métricas en BI.
- Compatible con el DW existente (sin rediseño Fase 4).

**Implicancias:**

- Requiere mayor rigor en carga y validación.
- Obliga a documentar claramente la relación LIC–OC.

**Conclusión:**  
✅ **Opción elegida** por ser la **única compatible** con:

- el negocio real,
- el DW construido,
- y la explotación analítica correcta.

---

### 3.3 Opción C — Cuadratura forzada LIC = OC (DESCARTADA)

**Descripción:**

- Forzar igualdad de montos LIC–OC por periodo.
- Ajustar datos para “cerrar” diferencias.

**Problemas críticos:**

- Ignora diferencias temporales reales.
- Oculta adjudicaciones parciales.
- Introduce datos artificiales.
- Riesgo alto de análisis engañoso.

**Conclusión:**  
❌ Descartada por comprometer la veracidad del análisis.

---

## 4. Decisión arquitectónica final (Gate 3)

Se adopta formalmente la **Opción B**, con las siguientes reglas:

1. LIC y OC se modelan como **hechos independientes**.
2. No se fuerza una relación 1:1.
3. La relación se realiza:
   - por claves de negocio,
   - por análisis temporal,
   - por agregaciones controladas.
4. Los KPIs deben:
   - derivarse desde el DW,
   - respetar el grano de cada hecho,
   - documentar explícitamente su lógica.

Esta decisión **NO implica rediseñar Fase 4**, sino **habilitar correctamente Fase 5**.

---

## 5. Impacto en KPIs y BI

Gracias a esta decisión:

- Se pueden construir KPIs como:
  - concentración de proveedores,
  - eficiencia de adjudicación,
  - ejecución presupuestaria,
  - trazabilidad LIC → OC.
- Se evita:
  - doble conteo,
  - inflado de montos,
  - filtros inconsistentes en Power BI.
- Se habilita un modelo semántico robusto y defendible.

---

## 6. Relación con Power BI (Gate 4)

Esta decisión es **condición necesaria** para Gate 4:

- Power BI se conectará exclusivamente al DW.
- El modelo semántico respetará los granos definidos.
- Las medidas DAX se apoyarán en:
  - SQL validado,
  - KPIs documentados.

No se permite BI sin Gate 3 aprobado.

---

## 7. Conclusión

La decisión adoptada en Gate 3:

- No es un compromiso,
- No es una solución “de conveniencia”,
- Es una decisión arquitectónica consciente y necesaria.

Refuerza:

- la calidad técnica del DW,
- la veracidad analítica,
- y el valor académico del TFM.

---

**Fin del documento.**
