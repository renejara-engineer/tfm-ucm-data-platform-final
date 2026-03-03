# Fase 5 — Criterios de Validación Analítica

## 1. Objetivo del documento

Este documento define los **criterios formales de validación analítica**
que deben cumplirse **obligatoriamente** antes de:

- realizar análisis exploratorio (EDA) sobre el Data Warehouse,
- calcular KPIs,
- construir dashboards en Power BI,
- redactar conclusiones analíticas en la memoria del TFM.

Su función es responder, de forma objetiva y reproducible, a la pregunta:

> **¿Los datos del Data Warehouse son analíticamente confiables para ser utilizados?**

Si la respuesta es **NO**, el proceso se detiene y se deben aplicar
correcciones en las fases previas (staging, DW o modelado).

---

## 2. Alcance de la validación

La validación analítica aplica a:

- **Periodo piloto:** `2024-09`
- **Hechos del Data Warehouse:**
  - `dw.fact_licitaciones`
  - `dw.fact_ordenes_compra`
- **Dimensiones asociadas:**
  - `dw.dim_fecha`
  - `dw.dim_organismo`
  - `dw.dim_proveedor`
  - `dw.dim_producto_onu`

Este documento **no cubre**:

- automatización mensual,
- cargas incrementales,
- periodos distintos al piloto.

---

## 3. Principios metodológicos

Toda validación analítica se rige por los siguientes principios:

1. **Sin hechos poblados no existe análisis**
2. **La integridad referencial es obligatoria**
3. **La coherencia de negocio prima sobre la coincidencia numérica**
4. **Power BI no corrige errores de datos**
5. **Toda validación debe ser reproducible en SQL**
6. **Un KPI inválido debe descartarse explícitamente**
7. **No se “maquillan” datos para que el dashboard funcione**

---

## 4. Estructura de la validación

La validación se organiza en **cinco niveles secuenciales**.  
Si un nivel falla, **no se continúa al siguiente**.

La validación se organiza en **cinco niveles secuenciales**.  
Si un nivel falla, **no se continúa al siguiente**.

| Nivel | Tipo de validación     | Pregunta clave                                 |
| ----- | ---------------------- | ---------------------------------------------- |
| 1     | Existencia de datos    | ¿Hay datos reales cargados?                    |
| 2     | Unicidad               | ¿Hay duplicados que inflen métricas?           |
| 3     | Integridad referencial | ¿El modelo estrella está completo?             |
| 4     | Coherencia analítica   | ¿Hay valores imposibles o incoherentes?        |
| 5     | Coherencia de negocio  | ¿LIC y OC respetan la lógica real del proceso? |

---

## 5. Nivel 1 — Existencia de datos (CRÍTICO)

### Objetivo

Confirmar que los hechos contienen **datos reales** para el periodo piloto.

### Qué se revisa

- `dw.fact_licitaciones` contiene registros en `2024-09`
- `dw.fact_ordenes_compra` contiene registros en `2024-09`

### SQL de referencia

```sql
SELECT COUNT(*) AS filas
FROM dw.fact_licitaciones
WHERE periodo = '2024-09';
sql
Copy code
SELECT COUNT(*) AS filas
FROM dw.fact_ordenes_compra
WHERE periodo = '2024-09';
Criterio de aceptación
Ambas consultas deben retornar filas > 0

Decisión
Si alguna retorna 0 filas → VALIDACIÓN FALLIDA


---

## 6. Nivel 2 — Unicidad de claves de negocio

### Objetivo
Evitar duplicación de hechos que distorsione KPIs y montos.

### Qué se revisa
- Unicidad de (`licitacion_bk`, `periodo`)
- Unicidad de (`orden_compra_bk`, `periodo`)

### SQL de referencia
```sql
SELECT licitacion_bk, periodo, COUNT(*) AS c
FROM dw.fact_licitaciones
GROUP BY licitacion_bk, periodo
HAVING COUNT(*) > 1;
```

#### Criterio de aceptación

La consulta no debe devolver filas

#### Decisión

Si hay duplicados → error de carga o grano incorrecto
Debe corregirse antes de continuar.

---

## 7. Nivel 3 — Integridad referencial (CRÍTICO)

### 7.1. Objetivo

Garantizar que todos los hechos están correctamente relacionados con las dimensiones del modelo estrella.

### 7.2. Qué se revisa

Que ninguna clave foránea sea NULL:

- `fecha_*_sk`
- `organismo_sk`
- `proveedor_sk`
- `producto_onu_sk`

### 7.3. SQL de referencia

```sql
SELECT
  SUM(CASE WHEN organismo_sk IS NULL THEN 1 ELSE 0 END) AS null_org,
  SUM(CASE WHEN proveedor_sk IS NULL THEN 1 ELSE 0 END) AS null_prov,
  SUM(CASE WHEN producto_onu_sk IS NULL THEN 1 ELSE 0 END) AS null_prod
FROM dw.fact_licitaciones
WHERE periodo = '2024-09';
```

#### 7.4. Criterio de aceptación

Todos los valores deben ser 0

#### 7.5. Decisión

Si existe algún NULL → dimensiones incompletas
BI bloqueado.

---

## 8. Nivel 4 — Coherencia analítica básica

### 8.1. Objetivo

Detectar valores imposibles desde el punto de vista analítico.

### 8.2. Qué se revisa

- Montos negativos
- Cantidades negativas
- Fechas fuera de rango
- Combinaciones ilógicas

### 8.3. SQL de referencia

```sql
SELECT COUNT(*) AS inconsistencias
FROM dw.fact_ordenes_compra
WHERE monto_total < 0;
```

#### 8.4. Criterio de aceptación

Conteo = 0

#### 8.5. Decisión

Si hay inconsistencias → revisar staging y tipado.

---

## 9. Nivel 5 — Coherencia de negocio LIC ↔ OC

### 9.1. Objetivo

Validar que la relación entre licitaciones y órdenes de compra respeta la lógica real del proceso de compras públicas.

### Consideraciones

- Una licitación puede tener múltiples proveedores.
- La ejecución puede ser multimes.
- No se exige cuadratura exacta mensual.

### 9.2. Qué se revisa

- Existen OC asociables a LIC.
- No hay OC sistemáticamente superiores al adjudicado LIC.
- Los desfases temporales son razonables.

### 9.3. Decisión

- Desfase temporal → aceptable
- Incoherencia estructural → error de modelo.

---

## 10. Validación de KPIs sensibles

### Caso: Cantidad de reclamos (LIC)

#### a. Qué se valida

- El campo existe en el DW.
- Es numérico.
- NULL se interpreta como 0.
- No existen valores negativos.

#### b. Decisión

Si el KPI no cumple → se descarta explícitamente
Nunca se oculta ni se “arregla” en BI.

---

## 11. Registro de evidencias

Cada validación debe dejar evidencia en:

```text
docs/05_project_log.md
```

Incluyendo:

- Fecha
- Periodo
- Nivel validado
- Resultado (OK / FAIL)
- Observaciones

---

## 12. Relación con Power BI

Power BI solo puede construirse si:

- Todas las validaciones están aprobadas.
- No existen excepciones abiertas.
- Los KPIs están definidos en `docs/fase5/03_modelo_analitico_kpis.md`.

Power BI no:

- corrige datos,
- redefine métricas,
- oculta errores.

definidos en este documento.

---

## 13. Estado del documento

**Estado:** Congelado

**Uso:** obligatorio antes de BI

**Cambios:** solo con justificación documentada

**Declaración final** Ningún análisis, KPI o visualización es válida si no supera los criterios definidos en este documento.

---

## 🧠 Lo importante (como arquitecto)

- Este **NO es solo un README**
- Es un **contrato metodológico**
- Protege:
  - tu TFM,
  - tus KPIs,
  - tu Power BI,
  - y tu tiempo

Si quieres, el **siguiente paso lógico** es:

👉 **alinear este documento con el 03 (KPIs)**
👉 o pasar directo a **`05_modelo_bi_powerbi.md`**

---

- Validación de coherencia monetaria post-fix (OC):
  - Percentiles esperables
  - Ausencia de outliers extremos
  - Suma consistente por moneda
