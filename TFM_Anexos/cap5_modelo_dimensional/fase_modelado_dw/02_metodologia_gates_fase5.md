# Fase 5 — Metodología por Gates  

## 1. Propósito del documento

Este documento define formalmente la **metodología por Gates aplicada en la Fase 5** del TFM *ChileCompra Data Platform*.

Su objetivo es:

- Establecer un **orden de ejecución no negociable**
- Definir **criterios de aprobación y rechazo** por etapa
- Evitar avances prematuros (especialmente hacia BI)
- Garantizar rigor técnico, trazabilidad analítica y coherencia académica

La metodología por Gates permite:

- Controlar el riesgo
- Aislar errores
- Asegurar que cada capa esté validada antes de avanzar

---

## 2. Principios metodológicos

La Fase 5 se rige por los siguientes principios:

1. No se avanza sin validación previa.
2. Cada Gate tiene un objetivo único.
3. Un Gate no aprobado bloquea el siguiente.
4. La evidencia es obligatoria.
5. La analítica prima sobre la estética.
6. El Data Warehouse es la única fuente válida para BI.

---

## 3. Visión general de los Gates de la Fase 5

| Gate | Nombre                         | Objetivo principal                              |
| ---- | ------------------------------ | ----------------------------------------------- |
| 0    | Control de cambios             | Congelar estado y evitar desviaciones           |
| 1    | Scaffold y preparación         | Preparar estructura documental y técnica        |
| 2    | SQL MART / Contrato analítico  | Definir datasets analíticos intermedios         |
| 3    | DW Analítico (facts y dims)    | Cargar y validar hechos y dimensiones           |
| 4    | BI / Power BI                  | Explotación visual y consumo analítico          |

---

## 4. Gate 0 — Control de cambios

### Objetivo del Gate 0

Asegurar que cualquier avance se realice sobre una **base conocida, congelada y auditada**.

### Actividades del Gate 0

- Definición explícita de fases cerradas
- Creación de `docs/fase5/00_continuidad_tecnica_gate3.md`
- Identificación de componentes prohibidos de modificar
- Generación de snapshot ZIP del TFM

### Criterio de aprobación del Gate 0

- Estado del proyecto claramente documentado
- Fuente de verdad única definida (ZIP)

### Riesgo mitigado por el Gate 0

- Reinterpretación del proyecto
- Pérdida de contexto entre chats
- Cambios no controlados

---

## 5. Gate 1 — Scaffold y preparación

### Objetivo del Gate 1

Preparar el entorno **documental y técnico mínimo** antes de cualquier implementación.

### Actividades del Gate 1

- Definición de la estructura documental de la Fase 5
- Creación de plantillas (scaffold) de documentos
- Revisión de scripts existentes
- Confirmación del periodo piloto disponible

### Criterio de aprobación del Gate 1

- Estructura documental definida
- Rol y alcance de cada documento claro
- Sin ejecución técnica aún

### Riesgo mitigado por el Gate 1

- Documentación reactiva
- Implementación sin relato
- Pérdida de trazabilidad

---

## 6. Gate 2 — SQL MART / Contrato Analítico

### Objetivo del Gate 2

Definir explícitamente **qué datos se consumirán analíticamente** y bajo qué grano.

### Actividades del Gate 2

- Construcción de MART analíticos (LIC y OC)
- Definición explícita del grano de consumo
- Validación de columnas, tipos y semántica
- Uso del MART como **contrato de consumo**, no como fuente BI directa

### Criterio de aprobación del Gate 2

- MART reproducible
- Granos claramente definidos
- Sin ambigüedad semántica

### Riesgo mitigado por el Gate 2

- KPIs inconsistentes
- BI conectado a capas incorrectas
- Inflación de métricas

---

## 7. Gate 3 — DW Analítico (facts y dims)

### Objetivo del Gate 3

Cargar el Data Warehouse con **datos analíticamente válidos** para el periodo piloto.

### Actividades del Gate 3

1. Carga de dimensiones desde staging
2. Validación de dimensiones (conteos mayores a cero)
3. Carga de hechos (LIC y OC)
4. Validación analítica:
   - Hechos no vacíos
   - Claves foráneas resueltas
   - Ausencia de duplicados
   - Coherencia de KPIs base

### Criterio de aprobación del Gate 3

- Dimensiones correctamente pobladas
- Hechos con datos reales
- Checklist SQL de validación aprobado

### Riesgo mitigado por el Gate 3

- BI sobre DW vacío
- Claves foráneas nulas
- Análisis engañoso

---

## 8. Gate 4 — BI / Power BI

### Objetivo del Gate 4

Explotar los datos del DW de forma **visual, coherente y defendible**.

### Actividades del Gate 4

- Conexión exclusiva a tablas del DW
- Definición del modelo semántico
- Construcción de KPIs en DAX basados en SQL validado
- Creación de dashboards analíticos

### Criterio de aprobación del Gate 4

- KPIs reproducibles desde SQL
- Dashboards coherentes con el negocio
- Sin contradicciones con el Gate 3

### Riesgo mitigado por el Gate 4

- BI visualmente atractivo pero incorrecto
- KPIs sin trazabilidad
- Interpretaciones erróneas

---

## 9. Relación entre Gates y fases previas

- **Fases 1 a 4**
  - Permanecen cerradas
  - Son prerequisito obligatorio de la Fase 5
- **Fase 5**
  - No redefine la arquitectura base
  - Valida y explota lo ya construido

Cada Gate actúa como **mecanismo de control**, no como burocracia.

---

## 10. Criterio formal de cierre de la Fase 5 (diseño)

La Fase 5 (diseño) se considera cerrada cuando:

- Los Gates 0 a 3 están documentados y aprobados
- El Gate 4 está definido a nivel conceptual
- Existe un plan claro de implementación y validación
- El proyecto está listo para ejecución técnica sin ambigüedad

---

## 11. Conclusión

La metodología por Gates aplicada en la Fase 5:

- Refleja buenas prácticas de ingeniería de datos
- Reduce riesgos técnicos y analíticos
- Aporta claridad metodológica al TFM
- Refuerza la calidad académica del proyecto

Esta metodología permite avanzar **con control, evidencia y coherencia**, asegurando que cada decisión esté justificada y validada antes de continuar.
