# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

**Trabajo Fin de Máster (TFM)**  

## Módulo ETL

## 1. Propósito

El directorio `etl/` contiene la implementación técnica del pipeline de
extracción, transformación y carga del proyecto *ChileCompra Data Platform*.

Este módulo materializa la transición desde la zona de entrada controlada
(`INBOX`) hacia el Data Warehouse relacional, bajo el esquema gobernado por
periodo descrito en la documentación arquitectónica oficial.

Su función es operacionalizar la arquitectura INBOX–STG–DW mediante código
ejecutable dentro de un contenedor Docker.

---

## 2. Rol dentro de la Arquitectura

En la arquitectura vigente, el módulo ETL cumple las siguientes funciones:

- Leer archivos estructurados desde `data/ChileCompraDL/00_INBOX/`.
- Validar su estructura y consistencia básica.
- Cargar datos en tablas STG por periodo.
- Ejecutar transformaciones hacia el modelo dimensional.
- Aplicar templates SQL parametrizados para consolidación analítica.
- Registrar el estado de ejecución en el Data Warehouse.

Este módulo no define la arquitectura ni el modelo dimensional;
únicamente implementa la lógica técnica que los materializa.

---

## 3. Estructura del Directorio

### 3.1 Archivos principales

- `Dockerfile`  
  Define el entorno de ejecución del pipeline dentro de contenedor.

- `run_period.py`  
  Script principal para ejecutar la carga de un periodo específico.

- `cli.py` y `cli_monthly.py`  
  Interfaces de ejecución parametrizada del proceso ETL.

- `app.py`  
  Punto de entrada para integración con servicios externos.

- `requirements.txt`  
  Dependencias necesarias para la ejecución del módulo.

---

### 3.2 Submódulos

#### `chilecompra/`

Contiene la lógica asociada a:

- Extracción desde fuentes estructuradas.
- Transformaciones intermedias.
- Carga hacia tablas STG.

#### `dw/`

Incluye scripts específicos para carga y mantenimiento de dimensiones
del Data Warehouse.

#### `sql_templates/`

Contiene templates SQL parametrizados utilizados para:

- Consolidación de dimensiones.
- Construcción de hechos.
- Ejecución de Gate 3.
- Implementación del modelo dimensional.

Estos templates aseguran separación entre lógica Python y lógica SQL,
favoreciendo claridad y mantenibilidad.

#### `pipelines/`

Agrupa configuraciones específicas de ejecución por escenario.

#### `scripts/`

Contiene utilidades auxiliares vinculadas a la operación del ETL.

---

## 4. Ejecución por Periodo

El pipeline se ejecuta bajo un esquema gobernado por periodo, lo que implica:

- Creación dinámica de tablas STG.
- Control de idempotencia.
- Registro formal de decisiones en `dw.etl_control_cargas`.
- Separación clara entre datos fuente y consolidación analítica.

Este enfoque permite reproducibilidad y auditoría técnica.

---

## 5. Relación con Otros Módulos

| Módulo                   | Relación                                                    |
|--------------------------|-------------------------------------------------------------|
| `arquitectura/`          | Define el diseño formal implementado por este módulo        |
| `db/`                    | Contiene la definición física del Data Warehouse            |
| `modelado_dw/`           | Documenta reglas formales aplicadas en las transformaciones |
| `orquestacion/`          | Automatiza la ejecución del ETL                             |
| `explotacion_analitica/` | Consume los resultados consolidados en el DW                |

---

## 6. Alcance

Este módulo constituye la implementación técnica del pipeline dentro del
alcance del Trabajo Fin de Máster.

No incluye lógica de visualización ni orquestación; dichas capas se
documentan en sus respectivos directorios.

---

## 7. Estado

El módulo ETL se considera estable y alineado con la arquitectura
vigente declarada en `arquitectura/README.md`.

---
