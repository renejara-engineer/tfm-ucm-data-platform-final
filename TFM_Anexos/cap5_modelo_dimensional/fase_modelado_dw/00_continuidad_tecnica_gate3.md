# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública  

**Universidad Complutense de Madrid (UCM)**  
**Máster en Data Science e Inteligencia Artificial**  
**Trabajo Fin de Máster (TFM)**

## Documento histórico de continuidad y decisiones técnicas (Gate 3)

## Advertencia de vigencia (lectura obligatoria)

El presente documento corresponde a un **registro histórico y de continuidad**
del proyecto **durante la ejecución del Gate 3 de la Fase 5**
(enero de 2026).

El **estado oficial, vigente e irreversible** del proyecto se encuentra
definido exclusivamente en:

- `docs/fase5/08_estado_actual_fase5.md`

Este documento **NO refleja el estado actual del proyecto**,  
**NO autoriza acciones técnicas**,  
y **NO debe utilizarse** para inferir el estado del Data Warehouse
ni de la capa de Business Intelligence.

---

## 1. Propósito del documento

Este documento tiene por objetivo:

- Preservar la **continuidad conceptual y técnica** entre sesiones de trabajo
  asistidas por ChatGPT.
- Registrar **decisiones técnicas relevantes** adoptadas durante Gate 3.
- Evitar redefiniciones indebidas de alcance, arquitectura o criterios ya
  evaluados y cerrados.

No constituye un documento de estado ni reemplaza a los documentos rectores
del proyecto.

---

## 2. Contexto histórico del proyecto (enero 2026)

Durante el periodo documentado en este archivo:

- El proyecto se encontraba en **Fase 5 — Gate 3**.
- El Data Warehouse estaba estructuralmente creado.
- Las cargas de hechos y dimensiones **aún no se encontraban completadas**.
- El foco del trabajo estaba en:
  - validación estructural,
  - definición de grano analítico,
  - corrección de anomalías de fuente.

Este contexto es **histórico** y no representa el estado actual del sistema.

---

## 3. Decisiones arquitectónicas NO negociables (históricas)

Durante Gate 3 se establecieron las siguientes decisiones,
consideradas **irreversibles** desde el punto de vista metodológico:

- Separación estricta de hechos:
  - `fact_licitaciones`
  - `fact_ordenes_compra`
- No imputación de valores faltantes en fechas críticas.
- Prohibición de correcciones semánticas en la capa BI.
- Trazabilidad obligatoria:
  **CLEAN → STG → DW → BI**
- Uso del Data Warehouse como **fuente única de verdad analítica**.

Estas decisiones permanecen vigentes como marco conceptual,
aunque el estado operativo haya evolucionado.

---

## 4. Snapshot histórico del estado técnico (Gate 3)

### 4.1 Estado del Data Warehouse (histórico)

- Esquema dimensional definido.
- Tablas de hechos creadas.
- Dimensiones creadas sin carga completa.
- DW estructuralmente correcto, pero aún no poblado de forma completa
  durante el periodo documentado.

### 4.2 Diagnóstico de bloqueo (histórico)

El avance se encontraba bloqueado por una anomalía detectada
en los montos monetarios de las Órdenes de Compra (OC),
producto del uso inconsistente de separadores decimales
en los archivos de origen.

---

## 5. CONTRATO TÉCNICO — Gate 3  

### Corrección monetaria OC (histórico, inamovible)

### 5.1 Regla establecida

Todos los montos monetarios de OC deben ser interpretados
bajo el siguiente criterio:

- El carácter `,` se interpreta como **separador decimal**.
- El carácter `.` se interpreta como **separador de miles**.
- No se permiten conversiones posteriores en BI.

### 5.2 Script oficial de corrección

```sql
UPDATE stg.oc
SET monto_total =
  CAST(
    REPLACE(
      REPLACE(monto_total_raw, '.', ''),
      ',', '.'
    ) AS NUMERIC
  );

```

---

El presente documento se conserva exclusivamente como registro histórico
y de continuidad metodológica, sin vigencia operativa sobre el estado actual
del proyecto.

---
