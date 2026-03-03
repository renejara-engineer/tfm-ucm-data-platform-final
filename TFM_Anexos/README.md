# TFM_Anexos  

## Índice general de anexos del informe académico

Este directorio contiene los anexos que respaldan el informe del
Trabajo Fin de Máster (TFM) correspondiente al Máster en Data Science
e Inteligencia Artificial (UCM).

Los anexos reúnen evidencia documental y técnica que complementa
los capítulos del informe, manteniendo separación entre:

- desarrollo conceptual (cuerpo del documento principal)
- evidencia técnica reproducible (repositorio GitHub)
- documentación contextual y normativa

---

## 📚 Estructura de anexos por capítulo

### Capítulo 2 — Marco normativo y fuente oficial de datos

`cap2_marco_normativo/`

Incluye documentación oficial compilada que sustenta el contexto
institucional y normativo del sistema ChileCompra, así como la
procedencia formal de los datos abiertos utilizados.

---

### Capítulo 4 — Extracción y normalización

`cap4_extraccion_normalizacion/`

Contiene referencias y documentación asociadas al proceso ETL de
extracción, normalización y estructuración inicial de datos.
La implementación técnica correspondiente se encuentra en el
directorio `etl/` del repositorio principal.

---

### Capítulo 5 — Modelo dimensional (Data Warehouse)

`cap5_modelo_dimensional/`

Incluye diagramas, esquemas y documentación asociada al diseño
relacional implementado en PostgreSQL, incluyendo estructuras
de hechos, dimensiones y relaciones.

---

### Capítulo 6 — Gobierno de datos y trazabilidad

`cap6_gobierno_datos/`

Reúne evidencia de controles estructurales, validaciones,
perfilamiento y trazabilidad del modelo analítico.

---

### Capítulo 7 — Operación reproducible y orquestación

`cap7_operacion_orquestacion/`

Documenta la automatización del pipeline mediante Docker y n8n,
incluyendo evidencia de ejecución y mecanismos de control
secuencial.

---

### Capítulo 8 — Consumo analítico (BI)

`cap8_consumo_bi/`

Incluye documentación y respaldo asociado a la capa de
explotación analítica y validación de coherencia DW → BI.

---

## Evidencia transversal

`evidencia_transversal/`

Directorio destinado a documentación de apoyo que no pertenece
exclusivamente a un único capítulo, pero respalda decisiones,
seguimiento metodológico o verificaciones técnicas globales.

---

## Relación con el repositorio principal

Los anexos aquí incluidos no duplican código ni artefactos
ejecutables. La implementación operativa completa se encuentra
en la raíz del repositorio (directorios `etl/`, `db/`, `docs/`,
`deployment/`, etc.).

Este esquema permite:

- mantener coherencia académica,
- evitar redundancia de archivos,
- preservar claridad estructural entre informe y repositorio técnico.
