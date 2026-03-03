# Fase 5 — Mapa de Impacto y Contrato de Implementación  

## Documento histórico de ejecución (Gate 3)

---

## Advertencia de vigencia (lectura obligatoria)

El presente documento corresponde al **contrato de ejecución, control y
orquestación** utilizado durante la implementación de la **Fase 5 (Gate 3)**
del proyecto *ChileCompra Data Platform*.

El **estado oficial, vigente e irreversible** del proyecto se encuentra
definido exclusivamente en:

- `docs/fase5/08_estado_actual_fase5.md`

Este archivo se conserva como **registro histórico y metodológico**.
No define el estado actual del proyecto ni autoriza nuevas ejecuciones
técnicas posteriores.

---

## Índice

1. Objetivo del documento  
2. Rol del documento dentro de Fase 5  
3. Fuente de verdad y estructura oficial de Fase 5  
4. Orden de lectura obligatorio  
5. Orden de ejecución técnica  
6. Artefactos técnicos involucrados  
   - 6.1 Artefactos que NO se tocan (Fases congeladas)  
   - 6.2 Artefactos que se modifican  
   - 6.3 Artefactos nuevos  
7. Relación Gates ↔ Documentos ↔ Ejecución  
8. Activación del pipeline y alcance real  
9. Relación con la memoria del TFM  
10. Estado del documento  

---

## 1. Objetivo del documento

Este documento define el **contrato formal y definitivo de implementación**
de la **Fase 5 — Capa Analítica y BI** del proyecto *ChileCompra Data Platform*.

Su objetivo fue declarar explícitamente, durante la ejecución de la Fase 5:

- la **estructura final oficial** de Fase 5,
- el **orden obligatorio de lectura** de la documentación,
- el **orden correcto de ejecución técnica**,
- los **artefactos que serán modificados o creados**,
- los **límites estrictos del cambio** (fases congeladas).

Este documento **no introduce diseño nuevo**.  
Formaliza, consolida y congela decisiones ya tomadas.

---

## 2. Rol del documento dentro de Fase 5

Durante la ejecución histórica de la Fase 5, este archivo actuó como:

- documento **maestro de orquestación**,
- contrato de continuidad entre chats,
- guía de ejecución para la implementación,
- protección frente a rediseños implícitos,
- referencia académica defendible ante tribunal.

Este rol se mantiene **a título histórico y metodológico**.

---

## 3. Fuente de verdad y estructura oficial de Fase 5

### 3.1 Fuente de verdad única

Durante la ejecución de Fase 5, la fuente normativa se consolidó en:

- docs/fase5/

Cualquier contenido previo ubicado en otras rutas
(ej. `docs/hallazgos/2025-12-19_fase5/`)
se considera **material histórico de apoyo**, no normativo.

---

### 3.2 Estructura final oficial de Fase 5

La estructura definitiva y congelada de Fase 5 es la siguiente:

docs/fase5/
├── 01_mapa_impacto_implementacion_fase5.md
├── 02_decisiones_arquitectonicas_gate3.md
├── 03_modelo_analitico_kpis.md
├── 04_criterios_validacion_analitica.md
├── 05_modelo_bi_powerbi.md
└── 06_checklist_verificacion_bi_pre_tfm.md

Notas importantes:

- No se agregan documentos adicionales a Fase 5.
- No se renumeran ni reubican estos archivos.
- Cada documento cumple un rol único y no redundante.

---

## 4. Orden de lectura obligatorio

Todo lector (humano o LLM) **debe seguir estrictamente** este orden:

1. `01_mapa_impacto_implementacion_fase5.md`  
   → contrato de ejecución y límites

2. `02_decisiones_arquitectonicas_gate3.md`  
   → decisiones de DW analítico (Gate 3)

3. `03_modelo_analitico_kpis.md`  
   → definición formal de KPIs

4. `04_criterios_validacion_analitica.md`  
   → validaciones SQL obligatorias

5. `05_modelo_bi_powerbi.md`  
   → modelo semántico y diseño BI (Gate 4)

6. `06_checklist_verificacion_bi_pre_tfm.md`  
   → checklist final previo a screenshots y memoria

Este orden **no es opcional** y garantiza continuidad total.

---

## 5. Orden de ejecución técnica (histórico)

Durante la ejecución histórica de la Fase 5, la implementación siguió
estrictamente el siguiente orden:

### Paso 1 — Gate 3: Data Warehouse Analítico

Se ejecutó la carga efectiva de:

- Dimensiones:
  - `dim_fecha`
  - `dim_organismo`
  - `dim_proveedor`
  - `dim_producto_onu`
- Hechos:
  - `fact_licitaciones`
  - `fact_ordenes_compra`

**Periodo piloto de referencia:** `2024-09`, posteriormente extendido
a periodos adicionales validados.

---

### Paso 2 — Validación analítica (SQL)

Se ejecutaron completamente los criterios definidos en:

- `04_criterios_validacion_analitica.md`

Ante fallos:

- se corrigió el DW,
- no se avanzó a BI hasta resolverlos.

---

### Paso 3 — Gate 4: BI / Power BI

- Construcción del modelo semántico.
- Implementación exclusiva de KPIs validados.
- Construcción de dashboards analíticos.

No se permitieron correcciones de datos en BI.

---

### Paso 4 — Checklist final y cierre

- Ejecución de `06_checklist_verificacion_bi_pre_tfm.md`
- Captura de screenshots
- Uso directo en la memoria del TFM

---

## 6. Artefactos técnicos involucrados

### 6.1 Artefactos que NO se tocan (Fases congeladas)

Las Fases 1–4 permanecieron estrictamente congeladas.
Cualquier cambio habría violado el contrato de Fase 5.

---

### 6.2 Artefactos que se modifican

| Artefacto          | Tipo de cambio       | Gate   |
|--------------------|----------------------|--------|
| Loaders DW         | Ajuste al grano real | Gate 3 |
| Dimensiones DW     | Carga efectiva       | Gate 3 |
| Hechos DW          | Carga efectiva       | Gate 3 |
| SQL de validación  | Ejecución            | Gate 3 |

Todos los cambios son controlados y documentados.

---

### 6.3 Artefactos nuevos

- Scripts SQL de carga DW (controlados).
- Queries SQL de validación.
- Archivo Power BI (`.pbix`).

No se crean scripts de automatización mensual en esta fase.

---

## 7. Relación Gates ↔ Documentos ↔ Ejecución

| Gate | Documento      | Rol                |
|------|----------------|--------------------|
| G0   | 01_mapa_impacto| Control de cambios |
| G3   | 02_decisiones  | DW analítico       |
| G3   | 03_modelo_kpis | KPIs               |
| G3   | 04_criterios   | Validación         |
| G4   | 05_modelo_bi   | BI                 |
| Final| 06_checklist   | Cierre             |

---

## 8. Activación del pipeline y alcance real

La automatización implementada durante la Fase 5 correspondió a un
**pipeline batch mensual controlado y validado**.

La automatización por eventos o integración directa vía API (INBOX)
quedó explícitamente **fuera del alcance del TFM** y se registra como
capacidad futura.

---

## 9. Relación con la memoria del TFM

Este documento permite:

- justificar formalmente la Fase 5,
- explicar decisiones arquitectónicas sin código,
- demostrar madurez metodológica,
- evitar contradicciones en conclusiones analíticas.

Es un documento **clave para la defensa**.

---

## 10. Estado del documento

- Estado: **Congelado**
- Rol: Contrato de ejecución Fase 5
- Cambios permitidos: solo mediante registro explícito en
  `docs/05_project_log.md`

---

## Declaración final

> La Fase 5 no repara errores previos.  
> **Habilita análisis reales, trazables y defendibles
> sobre una arquitectura ya validada.**
