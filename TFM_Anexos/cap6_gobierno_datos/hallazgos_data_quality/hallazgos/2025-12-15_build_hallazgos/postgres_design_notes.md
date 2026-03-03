# PostgreSQL – notas de diseño (Staging + DW)

Estas recomendaciones se basan en hallazgos típicos de datos CSV heterogéneos:
- variación de esquema entre meses (schema drift),
- errores de parsing/encoding,
- claves naturales inconsistentes,
- necesidad de trazabilidad (auditoría).

## Esquemas sugeridos
- `stg`: ingesta raw tipada como texto + columnas auditoría (archivo_origen, mes, hash_fila, fecha_ingesta)
- `clean`: normalizaciones (tipos, fechas, montos, normalización de códigos)
- `dw`: modelo dimensional (facts/dims)
- `meta`: metadatos, calidad, incidentes

## Estrategia de carga
1) Cargar a `stg` con `COPY` / `\copy` y columnas `TEXT`.
2) Aplicar reglas de limpieza hacia `clean`.
3) Poblar `dw` desde `clean` con claves surrogate.

## Duplicados
- Intra-mes: deduplicar en `stg` por `hash_fila` + `archivo_origen`.
- Inter-mes: NO borrar sin regla de negocio; reportar persistencias.

## Índices mínimos
- `stg`: (archivo_origen), (mes), (hash_fila)
- `dw`: claves surrogate + fechas (si se particiona por periodo)
