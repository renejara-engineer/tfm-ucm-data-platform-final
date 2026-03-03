# 00 – Dataset ChileCompra Summary Master

Generado automáticamente el 2025-12-10 19:42_

## 1. Contexto general

Este documento resume el estado real de los datasets utilizados en el Trabajo Fin de Máster sobre la
plataforma de datos de ChileCompra. Se basa en las descargas masivas de Datos Abiertos para:

- Licitaciones (reportes mensuales CSV).
- Órdenes de Compra (reportes mensuales CSV).
- Listado de organismos compradores.

El objetivo es disponer de una fotografía técnica consolidada que sirva de referencia en todas las fases
del TFM: arquitectura, ETL, modelado relacional, análisis, productivización y futura integración con
asistentes de inteligencia artificial.

## 2. Volumen y periodo cubierto

### 2.1 Licitaciones (LIC)

- Periodo cubierto: **2024-01 a 2025-12**.
- Número total de archivos mensuales: **14**.
- Filas totales aproximadas: **5,408,947**.
- Tamaño total en disco: **8,696.01 MB**.

### 2.2 Órdenes de Compra (OC)

- Periodo cubierto: **2024-01 a 2025-12**.
- Número total de archivos mensuales: **14**.
- Filas totales aproximadas: **5,622,180**.
- Tamaño total en disco: **9,028.80 MB**.

### 2.3 Organismos Públicos Compradores

- Archivo origen: **2025-10-17_Listado.csv**.
- Filas: **1,179**.
- Columnas: **4**.
- Tamaño aproximado: **0.07 MB**.

## 3. Estadísticas por archivo y duplicados

### 3.1 Archivos LIC

| file            |   year |   month |   rows |   dup_rows |   dup_pct | hash_limited   |   hash_limit_rows |
|:----------------|-------:|--------:|-------:|-----------:|----------:|:---------------|------------------:|
| LIC_2024-09.csv |   2024 |       9 | 178091 |        192 |    0.1078 | False          |           1000000 |
| LIC_2024-10.csv |   2024 |      10 | 219827 |        236 |    0.1074 | False          |           1000000 |
| LIC_2024-11.csv |   2024 |      11 | 530356 |       9602 |    1.8105 | False          |           1000000 |
| LIC_2024-12.csv |   2024 |      12 | 359662 |       4905 |    1.3638 | False          |           1000000 |
| LIC_2025-01.csv |   2025 |       1 |      2 |          0 |    0      | False          |           1000000 |
| LIC_2025-02.csv |   2025 |       2 | 598982 |      62975 |   10.5137 | False          |           1000000 |
| LIC_2025-03.csv |   2025 |       3 | 554409 |       5220 |    0.9415 | False          |           1000000 |
| LIC_2025-04.csv |   2025 |       4 | 556771 |       1887 |    0.3389 | False          |           1000000 |
| LIC_2025-05.csv |   2025 |       5 | 538324 |       2633 |    0.4891 | False          |           1000000 |
| LIC_2025-06.csv |   2025 |       6 | 472003 |       2597 |    0.5502 | False          |           1000000 |
| LIC_2025-07.csv |   2025 |       7 | 432435 |       1181 |    0.2731 | False          |           1000000 |
| LIC_2025-08.csv |   2025 |       8 | 418350 |       4231 |    1.0114 | False          |           1000000 |
| LIC_2025-09.csv |   2025 |       9 | 312383 |       1030 |    0.3297 | False          |           1000000 |
| LIC_2025-10.csv |   2025 |      10 | 237352 |       1633 |    0.688  | False          |           1000000 |

### 3.2 Archivos OC

| file           |   year |   month |   rows |   dup_rows |   dup_pct | hash_limited   |   hash_limit_rows |
|:---------------|-------:|--------:|-------:|-----------:|----------:|:---------------|------------------:|
| OC_2024-09.csv |   2024 |       9 | 396516 |          0 |         0 | False          |           1000000 |
| OC_2024-10.csv |   2024 |      10 | 508095 |          0 |         0 | False          |           1000000 |
| OC_2024-11.csv |   2024 |      11 | 470710 |          0 |         0 | False          |           1000000 |
| OC_2024-12.csv |   2024 |      12 | 411596 |          0 |         0 | False          |           1000000 |
| OC_2025-01.csv |   2025 |       1 | 360815 |          0 |         0 | False          |           1000000 |
| OC_2025-02.csv |   2025 |       2 | 354933 |          0 |         0 | False          |           1000000 |
| OC_2025-03.csv |   2025 |       3 |      2 |          0 |         0 | False          |           1000000 |
| OC_2025-04.csv |   2025 |       4 | 467832 |          0 |         0 | False          |           1000000 |
| OC_2025-05.csv |   2025 |       5 | 438074 |          0 |         0 | False          |           1000000 |
| OC_2025-06.csv |   2025 |       6 | 436932 |          0 |         0 | False          |           1000000 |
| OC_2025-07.csv |   2025 |       7 | 454386 |          0 |         0 | False          |           1000000 |
| OC_2025-08.csv |   2025 |       8 | 443201 |          0 |         0 | False          |           1000000 |
| OC_2025-09.csv |   2025 |       9 | 408749 |          0 |         0 | False          |           1000000 |
| OC_2025-10.csv |   2025 |      10 | 470339 |          0 |         0 | False          |           1000000 |

### 3.3 Duplicados entre meses (persistencia de filas)

La siguiente tabla resume un subconjunto de las filas que aparecen repetidas en más de un fichero mensual para LIC y OC, calculadas a partir de un hash de fila completa.

| dataset   |   n_hashes_repetidos |
|:----------|---------------------:|
| LIC       |                    0 |
| OC        |                    0 |

## 4. Diccionario de datos

En esta sección se documentan las columnas observadas en las muestras de trabajo. El objetivo es disponer de un esquema lógico realista sobre el que se construirá el Data Lake, el modelo relacional y los paneles analíticos.

### 4.1 Licitaciones (LIC)

> Nota: en esta tabla se muestran **todas las columnas detectadas** en el dataset, incluyendo recuentos de nulos, tipos de datos, ejemplos y banderas de calidad.

| columna                                                | columna_normalizada                                 | dtype   |   no_nulos |   pct_nulos |   n_unicos | ejemplo                                                                                                                                                                                        | es_constante   | es_numerico_mal_tipo   |
|:-------------------------------------------------------|:----------------------------------------------------|:--------|-----------:|------------:|-----------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------|:-----------------------|
| Cantidad                                               | cantidad                                            | object  |    5408945 |        0    |       7243 | 60                                                                                                                                                                                             | False          | True                   |
| Cantidad Ofertada                                      | cantidad_ofertada                                   | object  |    2028140 |       62.5  |       6687 | 60                                                                                                                                                                                             | False          | True                   |
| CantidadAdjudicada                                     | cantidadadjudicada                                  | object  |    2027933 |       62.51 |       7421 | 0                                                                                                                                                                                              | False          | True                   |
| CantidadReclamos                                       | cantidadreclamos                                    | float64 |    5408945 |        0    |       1151 | 185.0                                                                                                                                                                                          | False          | False                  |
| Codigo                                                 | codigo                                              | float64 |    5408945 |        0    |     136123 | 9291266.0                                                                                                                                                                                      | False          | False                  |
| CodigoEstado                                           | codigoestado                                        | float64 |    5408945 |        0    |         12 | 7.0                                                                                                                                                                                            | False          | False                  |
| CodigoEstadoLicitacion                                 | codigoestadolicitacion                              | float64 |    5408945 |        0    |         12 | 7.0                                                                                                                                                                                            | False          | False                  |
| CodigoExterno                                          | codigoexterno                                       | object  |    5408938 |        0    |     136119 | 2563-1-LR24                                                                                                                                                                                    | False          | False                  |
| CodigoMoneda                                           | codigomoneda                                        | object  |    5408945 |        0    |          5 | CLP                                                                                                                                                                                            | False          | False                  |
| CodigoOrganismo                                        | codigoorganismo                                     | float64 |    5408945 |        0    |       1087 | 7202.0                                                                                                                                                                                         | False          | False                  |
| CodigoProductoONU                                      | codigoproductoonu                                   | float64 |    5408941 |        0    |      11115 | 83111601.0                                                                                                                                                                                     | False          | False                  |
| CodigoProveedor                                        | codigoproveedor                                     | float64 |    5361070 |        0.89 |      46791 | 21214.0                                                                                                                                                                                        | False          | False                  |
| CodigoSucursalProveedor                                | codigosucursalproveedor                             | float64 |    5361070 |        0.89 |      47206 | 20628.0                                                                                                                                                                                        | False          | False                  |
| CodigoTipo                                             | codigotipo                                          | float64 |    5408945 |        0    |          2 | 1.0                                                                                                                                                                                            | False          | False                  |
| CodigoUnidad                                           | codigounidad                                        | float64 |    5408945 |        0    |       4241 | 3554.0                                                                                                                                                                                         | False          | False                  |
| Codigoitem                                             | codigoitem                                          | float64 |    5408945 |        0    |     607869 | 41607456.0                                                                                                                                                                                     | False          | False                  |
| ComunaUnidad                                           | comunaunidad                                        | object  |    4909582 |        9.23 |        346 | Providencia                                                                                                                                                                                    | False          | False                  |
| Contrato                                               | contrato                                            | float64 |    5056124 |        6.52 |          3 | 0.0                                                                                                                                                                                            | False          | False                  |
| Correlativo                                            | correlativo                                         | float64 |    5408945 |        0    |       1120 | 1.0                                                                                                                                                                                            | False          | False                  |
| Descripcion                                            | descripcion                                         | object  |    5408945 |        0    |     125076 | La Dirección General de Aeronáutica Civil, llama a propuesta pública para la contratación de los servicios de infraestructura crítica de comunicaciones, por un periodo de sesenta (60) meses. | False          | False                  |
| Descripcion linea Adquisicion                          | descripcion_linea_adquisicion                       | object  |    5394608 |        0.27 |     525048 | COMPONENTE 1 ENLACES RED WAN IP-MPLS, SD-WAN Y ACCESO A INTERNET                                                                                                                               | False          | False                  |
| DescripcionProveedor                                   | descripcionproveedor                                | object  |    2028071 |       62.51 |    1283971 | valor neto mensual                                                                                                                                                                             | False          | False                  |
| DireccionEntrega                                       | direccionentrega                                    | object  |    5408945 |        0    |          1 | 1900-01-01                                                                                                                                                                                     | True           | False                  |
| DireccionUnidad                                        | direccionunidad                                     | object  |    4944259 |        8.59 |       7046 | Miguel Claro 1314                                                                                                                                                                              | False          | False                  |
| DireccionVisita                                        | direccionvisita                                     | object  |    5408945 |        0    |          1 | 1900-01-01                                                                                                                                                                                     | True           | False                  |
| EsBaseTipo                                             | esbasetipo                                          | float64 |    5408945 |        0    |          1 | 0.0                                                                                                                                                                                            | True           | False                  |
| EsRenovable                                            | esrenovable                                         | float64 |    5408945 |        0    |          1 | 0.0                                                                                                                                                                                            | True           | False                  |
| Estado                                                 | estado                                              | object  |    5408945 |        0    |          6 | Desierta (o art. 3 ó 9 Ley 19.886)                                                                                                                                                             | False          | False                  |
| Estado Oferta                                          | estado_oferta                                       | object  |    5408945 |        0    |          2 | Aceptada                                                                                                                                                                                       | False          | False                  |
| EstadoCS                                               | estadocs                                            | float64 |    5408945 |        0    |          4 | 1.0                                                                                                                                                                                            | False          | False                  |
| EstadoEtapas                                           | estadoetapas                                        | float64 |    5408945 |        0    |          3 | 1.0                                                                                                                                                                                            | False          | False                  |
| EstadoPublicidadOfertas                                | estadopublicidadofertas                             | float64 |    5408945 |        0    |          2 | 1.0                                                                                                                                                                                            | False          | False                  |
| Estimacion                                             | estimacion                                          | float64 |    5391475 |        0.32 |          3 | 2.0                                                                                                                                                                                            | False          | False                  |
| Etapas                                                 | etapas                                              | float64 |    5408945 |        0    |          2 | 1.0                                                                                                                                                                                            | False          | False                  |
| ExtensionPlazo                                         | extensionplazo                                      | float64 |    5408945 |        0    |          2 | 0.0                                                                                                                                                                                            | False          | False                  |
| FechaActoAperturaEconomica                             | fechaactoaperturaeconomica                          | object  |    5408945 |        0    |        439 | 2024-12-10                                                                                                                                                                                     | False          | False                  |
| FechaActoAperturaTecnica                               | fechaactoaperturatecnica                            | object  |    5408945 |        0    |        424 | 2024-12-10                                                                                                                                                                                     | False          | False                  |
| FechaAdjudicacion                                      | fechaadjudicacion                                   | object  |    5408933 |        0    |        662 | 2025-01-29                                                                                                                                                                                     | False          | False                  |
| FechaAprobacion                                        | fechaaprobacion                                     | object  |    4484109 |       17.1  |        527 | 2024-10-28                                                                                                                                                                                     | False          | False                  |
| FechaCierre                                            | fechacierre                                         | object  |    5408945 |        0    |        347 | 2024-12-09                                                                                                                                                                                     | False          | False                  |
| FechaCreacion                                          | fechacreacion                                       | object  |    5408945 |        0    |        581 | 2024-01-08                                                                                                                                                                                     | False          | False                  |
| FechaEntregaAntecedentes                               | fechaentregaantecedentes                            | object  |    5408945 |        0    |          1 | 1900-01-01                                                                                                                                                                                     | True           | False                  |
| FechaEnvioOferta                                       | fechaenviooferta                                    | object  |    5360809 |        0.89 |        432 | 2024-12-09                                                                                                                                                                                     | False          | False                  |
| FechaEstimadaAdjudicacion                              | fechaestimadaadjudicacion                           | object  |    5408945 |        0    |        724 | 2025-04-16                                                                                                                                                                                     | False          | False                  |
| FechaEstimadaFirma                                     | fechaestimadafirma                                  | object  |    5408945 |        0    |        493 | 2025-06-16                                                                                                                                                                                     | False          | False                  |
| FechaFinal                                             | fechafinal                                          | object  |    5408945 |        0    |        453 | 2024-10-04                                                                                                                                                                                     | False          | False                  |
| FechaInicio                                            | fechainicio                                         | object  |    5408945 |        0    |        404 | 2024-09-09                                                                                                                                                                                     | False          | False                  |
| FechaPubRespuestas                                     | fechapubrespuestas                                  | object  |    5408945 |        0    |        462 | 2024-10-18                                                                                                                                                                                     | False          | False                  |
| FechaPublicacion                                       | fechapublicacion                                    | object  |    5408945 |        0    |        372 | 2024-09-09                                                                                                                                                                                     | False          | False                  |
| FechaSoporteFisico                                     | fechasoportefisico                                  | object  |    5408945 |        0    |        311 | 2024-12-09                                                                                                                                                                                     | False          | False                  |
| FechaTiempoEvaluacion                                  | fechatiempoevaluacion                               | float64 |    5408945 |        0    |         81 | 14.0                                                                                                                                                                                           | False          | False                  |
| FechaVisitaTerreno                                     | fechavisitaterreno                                  | object  |    5408945 |        0    |          1 | 1900-01-01                                                                                                                                                                                     | True           | False                  |
| FechasUsuario                                          | fechasusuario                                       | float64 |    5408945 |        0    |         18 | 9.0                                                                                                                                                                                            | False          | False                  |
| FuenteFinanciamiento                                   | fuentefinanciamiento                                | object  |    3151273 |       41.74 |      15117 | DGAC - Recursos Propios                                                                                                                                                                        | False          | False                  |
| Informada                                              | informada                                           | float64 |    5408945 |        0    |          2 | 0.0                                                                                                                                                                                            | False          | False                  |
| JustificacionMontoEstimado                             | justificacionmontoestimado                          | object  |    1674248 |       69.05 |      20350 | 0                                                                                                                                                                                              | False          | False                  |
| JustificacionPublicidad                                | justificacionpublicidad                             | object  |     357393 |       93.39 |        428 | Todas las ofertas técnicas serán visibles al público en general, través del portal www.mercadopublico.cl, desde el momento de la apertura electrónica.                                         | False          | False                  |
| Link                                                   | link                                                | object  |    5408945 |        0    |     136120 | <http://www.mercadopublico.cl/fichaLicitacion.html?idLicitacion=2563-1-LR24>                                                                                                                   | False          | False                  |
| Modalidad                                              | modalidad                                           | object  |    5408945 |        0    |          4 | RFB_CONTRACT_PAYMENT_METHOD_30_DAYS                                                                                                                                                            | False          | False                  |
| Moneda Adquisicion                                     | moneda_adquisicion                                  | object  |    5408945 |        0    |          5 | Peso Chileno                                                                                                                                                                                   | False          | False                  |
| Moneda de la Oferta                                    | moneda_de_la_oferta                                 | object  |    5408945 |        0    |          5 | Peso Chileno                                                                                                                                                                                   | False          | False                  |
| Monto Estimado Adjudicado                              | monto_estimado_adjudicado                           | object  |    4679475 |       13.49 |      63627 | 1480000                                                                                                                                                                                        | False          | True                   |
| MontoEstimado                                          | montoestimado                                       | object  |    5364471 |        0.82 |      42226 | 1e+10                                                                                                                                                                                          | False          | True                   |
| MontoLineaAdjudica                                     | montolineaadjudica                                  | object  |    2027933 |       62.51 |     138127 | 0                                                                                                                                                                                              | False          | True                   |
| MontoUnitarioOferta                                    | montounitariooferta                                 | object  |    2028140 |       62.5  |     343467 | 105312159,76                                                                                                                                                                                   | False          | True                   |
| Nombre                                                 | nombre                                              | object  |    5408945 |        0    |     126052 | Infraestructura Crítica de Comunicaciones                                                                                                                                                      | False          | False                  |
| Nombre de la Oferta                                    | nombre_de_la_oferta                                 | object  |    5361069 |        0.89 |     314473 | Licitacion red WAN Infraestructura Crítica de Comunicaciones                                                                                                                                   | False          | False                  |
| Nombre linea Adquisicion                               | nombre_linea_adquisicion                            | object  |    5408945 |        0    |      10954 | Servicio de redes para mejorar la señal de telecomunicaciones                                                                                                                                  | False          | False                  |
| Nombre producto genrico                                | nombre_producto_genrico                             | object  |    5408941 |        0    |      10823 | SERVICIO DE REDES PARA MEJORAR LA SEÑAL DE TELECOMUNICACIONES                                                                                                                                  | False          | False                  |
| NombreOrganismo                                        | nombreorganismo                                     | object  |    5408945 |        0    |       1074 | DIRECCION GENERAL DE AERONAUTICA CIVIL                                                                                                                                                         | False          | False                  |
| NombreProveedor                                        | nombreproveedor                                     | object  |    5361052 |        0.89 |      46857 | TELEFONICA EMPRESAS CHILE SA                                                                                                                                                                   | False          | False                  |
| NombreUnidad                                           | nombreunidad                                        | object  |    5408945 |        0    |       3389 | UNIDAD DE COMPRA CONTRATOS NACIONALES                                                                                                                                                          | False          | False                  |
| NumeroAprobacion                                       | numeroaprobacion                                    | object  |    4483365 |       17.11 |      30741 | 176                                                                                                                                                                                            | False          | False                  |
| NumeroOferentes                                        | numerooferentes                                     | float64 |    5408945 |        0    |         81 | 2.0                                                                                                                                                                                            | False          | False                  |
| Obras                                                  | obras                                               | float64 |    5408945 |        0    |          2 | 0.0                                                                                                                                                                                            | False          | False                  |
| ObservacionContrato                                    | observacioncontrato                                 | object  |    1192486 |       77.95 |      11679 | Monto referencial incluye impuestos.                                                                                                                                                           | False          | False                  |
| Oferta seleccionada                                    | oferta_seleccionada                                 | object  |    5408945 |        0    |          2 | No Seleccionada                                                                                                                                                                                | False          | False                  |
| PeriodoTiempoRenovacion                                | periodotiemporenovacion                             | float64 |          0 |      100    |          0 |                                                                                                                                                                                                | True           | False                  |
| ProhibicionContratacion                                | prohibicioncontratacion                             | object  |    1385249 |       74.39 |      11271 | En todo evento el adjudicado es el responsable de todas las obligaciones contraídas con la Municipalidad en virtud del contrato, se prohíbe subcontratación, por la naturaleza del servicio.   | False          | False                  |
| RazonSocialProveedor                                   | razonsocialproveedor                                | object  |    5361070 |        0.89 |      46999 | TELEFONICA EMPRESAS CHILE SA                                                                                                                                                                   | False          | False                  |
| RegionUnidad                                           | regionunidad                                        | object  |    5408943 |        0    |         17 | Región Metropolitana de Santiago                                                                                                                                                               | False          | False                  |
| Rubro1                                                 | rubro1                                              | object  |    5408941 |        0    |         58 | SERVICIOS BÁSICOS Y DE INFORMACIÓN PÚBLICA                                                                                                                                                     | False          | False                  |
| Rubro2                                                 | rubro2                                              | object  |    5408941 |        0    |        347 | TELECOMUNICACIONES                                                                                                                                                                             | False          | False                  |
| Rubro3                                                 | rubro3                                              | object  |    5408941 |        0    |       1823 | COMUNICACIONES MÓVILES                                                                                                                                                                         | False          | False                  |
| RutProveedor                                           | rutproveedor                                        | object  |    5361070 |        0.89 |      46789 | 78.703.410-1                                                                                                                                                                                   | False          | False                  |
| RutUnidad                                              | rutunidad                                           | object  |    5408945 |        0    |       1719 | 61.104.000-8                                                                                                                                                                                   | False          | False                  |
| SubContratacion                                        | subcontratacion                                     | float64 |    5408945 |        0    |          2 | 0.0                                                                                                                                                                                            | False          | False                  |
| Tiempo                                                 | tiempo                                              | float64 |    2467686 |       54.38 |        413 | 60.0                                                                                                                                                                                           | False          | False                  |
| TiempoDuracionContrato                                 | tiempoduracioncontrato                              | float64 |    5408945 |        0    |        414 | 60.0                                                                                                                                                                                           | False          | False                  |
| Tipo                                                   | tipo                                                | object  |    5408945 |        0    |         13 | LR                                                                                                                                                                                             | False          | False                  |
| Tipo de Adquisicion                                    | tipo_de_adquisicion                                 | object  |    5408945 |        0    |         13 | Licitación Pública Mayor a 5000 (LR)                                                                                                                                                           | False          | False                  |
| TipoAprobacion                                         | tipoaprobacion                                      | float64 |    4484109 |       17.1  |          6 | 2.0                                                                                                                                                                                            | False          | False                  |
| TipoConvocatoria                                       | tipoconvocatoria                                    | float64 |    5408945 |        0    |          2 | 1.0                                                                                                                                                                                            | False          | False                  |
| TipoDuracionContrato                                   | tipoduracioncontrato                                | object  |      16913 |       99.69 |          2 | RFB_CONTRACT_TIME_PERIOD_INMEDIATE_EXECUTION                                                                                                                                                   | False          | False                  |
| TipoPago                                               | tipopago                                            | float64 |    5408945 |        0    |          4 | 1.0                                                                                                                                                                                            | False          | False                  |
| TomaRazon                                              | tomarazon                                           | float64 |    5408945 |        0    |          2 | 0.0                                                                                                                                                                                            | False          | False                  |
| UnidadMedida                                           | unidadmedida                                        | object  |    5408943 |        0    |         93 | Mes                                                                                                                                                                                            | False          | False                  |
| UnidadTiempo                                           | unidadtiempo                                        | object  |    5408945 |        0    |          5 | RFB_TIME_PERIOD_DAYS                                                                                                                                                                           | False          | False                  |
| UnidadTiempoContratoLicitacion                         | unidadtiempocontratolicitacion                      | float64 |    5408945 |        0    |          3 | 2.0                                                                                                                                                                                            | False          | False                  |
| UnidadTiempoDuracionContrato                           | unidadtiempoduracioncontrato                        | float64 |    5408945 |        0    |          5 | 4.0                                                                                                                                                                                            | False          | False                  |
| UnidadTiempoEvaluacion                                 | unidadtiempoevaluacion                              | object  |    5333109 |        1.4  |          4 | RFB_TIME_PERIOD_DAYS                                                                                                                                                                           | False          | False                  |
| Valor Total Ofertado                                   | valor_total_ofertado                                | object  |    2028140 |       62.5  |     481992 | 6318729585,6                                                                                                                                                                                   | False          | True                   |
| ValorTiempoRenovacion                                  | valortiemporenovacion                               | float64 |    5408945 |        0    |          1 | 0.0                                                                                                                                                                                            | True           | False                  |
| VisibilidadMonto                                       | visibilidadmonto                                    | float64 |    5408945 |        0    |          2 | 0.0                                                                                                                                                                                            | False          | False                  |
| __source_file                                          | source_file                                         | object  |    5408947 |        0    |         14 | LIC_2024-09.csv                                                                                                                                                                                | False          | False                  |
| id_licitacion,fechapublicacion,fechacierre,descripcion | id_licitacionfechapublicacionfechacierredescripcion | object  |          2 |      100    |          2 | 12345,01-01-2025,10-01-2025,Compra de notebooks                                                                                                                                                | False          | False                  |
| sector                                                 | sector                                              | object  |    5323382 |        1.58 |          8 | Gob. Central, Universidades                                                                                                                                                                    | False          | False                  |

### 4.2 Órdenes de Compra (OC)

> Nota: en esta tabla se muestran **todas las columnas detectadas** en el dataset, incluyendo recuentos de nulos, tipos de datos, ejemplos y banderas de calidad.

| columna                    | columna_normalizada        | dtype   |   no_nulos |   pct_nulos |   n_unicos | ejemplo                                                                                                                              | es_constante   | es_numerico_mal_tipo   |
|:---------------------------|:---------------------------|:--------|-----------:|------------:|-----------:|:-------------------------------------------------------------------------------------------------------------------------------------|:---------------|:-----------------------|
| ActividadComprador         | actividadcomprador         | object  |    4358277 |       22.48 |       1012 | Servicio Público                                                                                                                     | False          | False                  |
| ActividadProveedor         | actividadproveedor         | object  |    5573555 |        0.86 |      26498 | OBRAS MENORES EN CONSTRUCCION (CONTRATISTAS, ALBAN                                                                                   | False          | False                  |
| CantidadEvaluacion         | cantidadevaluacion         | float64 |    5622178 |        0    |         95 | 0.0                                                                                                                                  | False          | False                  |
| Cargos                     | cargos                     | object  |    5622178 |        0    |       6874 | 0                                                                                                                                    | False          | True                   |
| Categoria                  | categoria                  | object  |    4823503 |       14.21 |       2002 | Servicios de construcción y mantenimiento / Construcción de edificios en general / Construcción de obras civiles y infraestructuras  | False          | False                  |
| CiudadUnidadCompra         | ciudadunidadcompra         | object  |    5523716 |        1.75 |        586 | Camarones                                                                                                                            | False          | False                  |
| Codigo                     | codigo                     | object  |    5622178 |        0    |    2070139 | 5858-14-SE22                                                                                                                         | False          | False                  |
| CodigoAbreviadoTipoOC      | codigoabreviadotipooc      | object  |    5622178 |        0    |          6 | SE                                                                                                                                   | False          | False                  |
| CodigoLicitacion           | codigolicitacion           | object  |    2015371 |       64.15 |     138413 | 5858-1-LE22                                                                                                                          | False          | False                  |
| CodigoOrganismoPublico     | codigoorganismopublico     | float64 |    5622178 |        0    |       1160 | 294421.0                                                                                                                             | False          | False                  |
| CodigoProveedor            | codigoproveedor            | float64 |    5622160 |        0    |      83481 | 287333.0                                                                                                                             | False          | False                  |
| CodigoSucursal             | codigosucursal             | float64 |    5622160 |        0    |      85009 | 293454.0                                                                                                                             | False          | False                  |
| CodigoTipo                 | codigotipo                 | float64 |    5622178 |        0    |          6 | 8.0                                                                                                                                  | False          | False                  |
| CodigoUnidadCompra         | codigounidadcompra         | float64 |    5622178 |        0    |       5843 | 300526.0                                                                                                                             | False          | False                  |
| Codigo_ConvenioMarco       | codigo_conveniomarco       | object  |     799399 |       85.78 |         25 | 2239-9-LR22                                                                                                                          | False          | False                  |
| ComunaProveedor            | comunaproveedor            | object  |    4792264 |       14.76 |        932 | Arica                                                                                                                                | False          | False                  |
| Descripcion/Obervaciones   | descripcion_obervaciones   | object  |    5615228 |        0.12 |    1709056 | Mejoramiento de Infraestructura Sanitaria DESDE 5858-1-LE22                                                                          | False          | False                  |
| DescripcionTipoOC          | descripciontipooc          | object  |    5622178 |        0    |          6 | Sin emisión automática                                                                                                               | False          | False                  |
| Descuentos                 | descuentos                 | object  |    5622178 |        0    |      11158 | 0                                                                                                                                    | False          | True                   |
| EsCompraAgil               | escompraagil               | object  |    5622178 |        0    |          2 | No                                                                                                                                   | False          | False                  |
| EsTratoDirecto             | estratodirecto             | object  |    4778087 |       15.01 |          2 | No                                                                                                                                   | False          | False                  |
| EspecificacionComprador    | especificacioncomprador    | object  |    5536039 |        1.53 |    3644997 | Instalación de cinco soluciones individuales de alcantarillado, con tratamiento de aguas mediante fosa séptica y pozo absorbente     | False          | False                  |
| EspecificacionProveedor    | especificacionproveedor    | object  |    3797104 |       32.46 |    2323086 | Mejoramiento de Infraestructura Sanitaria                                                                                            | False          | False                  |
| Estado                     | estado                     | object  |    5622178 |        0    |          5 | Aceptada                                                                                                                             | False          | False                  |
| EstadoProveedor            | estadoproveedor            | object  |    5622177 |        0    |          6 | Aceptada                                                                                                                             | False          | False                  |
| FechaAceptacion            | fechaaceptacion            | object  |    5515510 |        1.9  |        438 | 2024-09-23                                                                                                                           | False          | False                  |
| FechaCancelacion           | fechacancelacion           | object  |        109 |      100    |         30 | 2024-09-03                                                                                                                           | False          | False                  |
| FechaCreacion              | fechacreacion              | object  |    5622178 |        0    |        717 | 2022-05-12                                                                                                                           | False          | False                  |
| FechaEnvio                 | fechaenvio                 | object  |    5622178 |        0    |        395 | 2024-09-23                                                                                                                           | False          | False                  |
| FechaSolicitudCancelacion  | fechasolicitudcancelacion  | object  |    5428233 |        3.45 |        610 | 2024-09-23                                                                                                                           | False          | False                  |
| Financiamiento             | financiamiento             | object  |    3563021 |       36.63 |     214983 | 3190                                                                                                                                 | False          | False                  |
| Forma de Pago              | forma_de_pago              | object  |    5550160 |        1.28 |          3 | Otro, Ver Instrucciones                                                                                                              | False          | False                  |
| FormaPago                  | formapago                  | float64 |    5622141 |        0    |          5 | 39.0                                                                                                                                 | False          | False                  |
| ID                         | id                         | float64 |    5622178 |        0    |    2070139 | 45885078.0                                                                                                                           | False          | False                  |
| IDItem                     | iditem                     | float64 |    5622175 |        0    |    5622175 | 122139702.0                                                                                                                          | False          | False                  |
| Impuestos                  | impuestos                  | object  |    5622178 |        0    |     593277 | 7821043,72                                                                                                                           | False          | True                   |
| Link                       | link                       | object  |    5622178 |        0    |    2070139 | http://www.mercadopublico.cl/PurchaseOrder/Modules/PO/DetailsPurchaseOrder.aspx?codigoOC=5858-14-SE22                                | False          | False                  |
| MontoTotalOC               | montototaloc               | object  |    5622178 |        0    |     747027 | 48984431,72                                                                                                                          | False          | True                   |
| MontoTotalOC_PesosChilenos | montototaloc_pesoschilenos | object  |    5622178 |        0    |     754480 | 48984431,72                                                                                                                          | False          | True                   |
| Nombre                     | nombre                     | object  |    5622178 |        0    |    1627236 | ORDEN DE COMPRA DESDE 5858-1-LE22                                                                                                    | False          | False                  |
| NombreProveedor            | nombreproveedor            | object  |    5622148 |        0    |      81798 | CLAUDIA ANDREA MAUREIRA AHUMADA                                                                                                      | False          | False                  |
| NombreroductoGenerico      | nombreroductogenerico      | object  |    5622175 |        0    |      97504 | Construcción de obras civiles                                                                                                        | False          | False                  |
| OrganismoPublico           | organismopublico           | object  |    5622178 |        0    |       1147 | Ilustre Municipalidad de Camarones                                                                                                   | False          | False                  |
| Pais                       | pais                       | object  |    5419029 |        3.61 |          4 | CL                                                                                                                                   | False          | False                  |
| PaisProveedor              | paisproveedor              | object  |    2835987 |       49.56 |         27 | Chile                                                                                                                                | False          | False                  |
| PaisUnidadCompra           | paisunidadcompra           | object  |    5419029 |        3.61 |          4 | CL                                                                                                                                   | False          | False                  |
| PorcentajeIva              | porcentajeiva              | object  |    5622178 |        0    |          7 | 19                                                                                                                                   | False          | True                   |
| ProcedenciaOC              | procedenciaoc              | object  |    4778087 |       15.01 |         36 | Proveniente de licitación pública                                                                                                    | False          | False                  |
| PromedioCalificacion       | promediocalificacion       | object  |    5622178 |        0    |        456 | 0                                                                                                                                    | False          | True                   |
| RegionProveedor            | regionproveedor            | object  |    4753371 |       15.45 |        371 | Región de Arica y Parinacota                                                                                                         | False          | False                  |
| RegionUnidadCompra         | regionunidadcompra         | object  |    5524156 |        1.74 |         16 | Región de Arica y Parinacota                                                                                                         | False          | False                  |
| RubroN1                    | rubron1                    | object  |    4823503 |       14.21 |         58 | Servicios de construcción y mantenimiento                                                                                            | False          | False                  |
| RubroN2                    | rubron2                    | object  |    4823503 |       14.21 |        357 | Construcción de edificios en general                                                                                                 | False          | False                  |
| RubroN3                    | rubron3                    | object  |    4823503 |       14.21 |       2002 | Construcción de obras civiles y infraestructuras                                                                                     | False          | False                  |
| RutSucursal                | rutsucursal                | object  |    5619782 |        0.04 |      83375 | 15.084.723-0                                                                                                                         | False          | False                  |
| RutUnidadCompra            | rutunidadcompra            | object  |    5622178 |        0    |       2009 | 69.251.000-3                                                                                                                         | False          | False                  |
| Sucursal                   | sucursal                   | object  |    5617281 |        0.09 |      85830 | maclau                                                                                                                               | False          | False                  |
| Tipo                       | tipo                       | object  |    5622178 |        0    |          6 | SE                                                                                                                                   | False          | False                  |
| TipoDespacho               | tipodespacho               | float64 |    5622178 |        0    |          7 | 12.0                                                                                                                                 | False          | False                  |
| TipoImpuesto               | tipoimpuesto               | object  |    5622178 |        0    |          6 | IVA                                                                                                                                  | False          | False                  |
| TipoMonedaOC               | tipomonedaoc               | object  |    5622178 |        0    |          5 | CLP                                                                                                                                  | False          | False                  |
| TotalNetoOC                | totalnetooc                | object  |    5622178 |        0    |     686289 | 41163388                                                                                                                             | False          | True                   |
| UnidadCompra               | unidadcompra               | object  |    5622178 |        0    |       4843 | Unidad Técnica                                                                                                                       | False          | False                  |
| UnidadMedida               | unidadmedida               | object  |    4822646 |       14.22 |         98 | Unidad                                                                                                                               | False          | False                  |
| __source_file              | source_file                | object  |    5622180 |        0    |         14 | OC_2024-09.csv                                                                                                                       | False          | False                  |
| cantidad                   | cantidad                   | object  |    5622175 |        0    |      26918 | 1                                                                                                                                    | False          | True                   |
| codigoCategoria            | codigocategoria            | float64 |    4823503 |       14.21 |       1985 | 72131700.0                                                                                                                           | False          | False                  |
| codigoEstado               | codigoestado               | float64 |    5622178 |        0    |          5 | 6.0                                                                                                                                  | False          | False                  |
| codigoEstadoProveedor      | codigoestadoproveedor      | float64 |    5622178 |        0    |          7 | 4.0                                                                                                                                  | False          | False                  |
| codigoProductoONU          | codigoproductoonu          | float64 |    5622175 |        0    |      14892 | 72131702.0                                                                                                                           | False          | False                  |
| fechaUltimaModificacion    | fechaultimamodificacion    | object  |    5622178 |        0    |        599 | 2024-09-23                                                                                                                           | False          | False                  |
| monedaItem                 | monedaitem                 | object  |    5622175 |        0    |          5 | CLP                                                                                                                                  | False          | False                  |
| precioNeto                 | precioneto                 | object  |    5622175 |        0    |     487637 | 41163388                                                                                                                             | False          | True                   |
| sector                     | sector                     | object  |    5543101 |        1.41 |          7 | Municipalidades                                                                                                                      | False          | False                  |
| tieneItems                 | tieneitems                 | float64 |    5622178 |        0    |          2 | 1.0                                                                                                                                  | False          | False                  |
| totalCargos                | totalcargos                | object  |    5622175 |        0    |        346 | 0                                                                                                                                    | False          | True                   |
| totalDescuentos            | totaldescuentos            | object  |    5622175 |        0    |        937 | 0                                                                                                                                    | False          | True                   |
| totalImpuestos             | totalimpuestos             | float64 |    3142081 |       44.11 |          3 | 0.0                                                                                                                                  | False          | False                  |
| totalLineaNeto             | totallineaneto             | object  |    5622137 |        0    |     710832 | 41163388                                                                                                                             | False          | True                   |
| x                          | x                          | object  |          2 |      100    |          2 | 42000 927 [Microsoft][ODBC SQL Server Driver][SQL Server]Database 'DCCPPlatform' cannot be opened. It is in the middle of a restore. | False          | False                  |

### 4.3 Organismos Públicos Compradores

> Nota: en esta tabla se muestran **todas las columnas detectadas** en el dataset, incluyendo recuentos de nulos, tipos de datos, ejemplos y banderas de calidad.

| columna           | columna_normalizada   | dtype   |   no_nulos |   pct_nulos |   n_unicos | ejemplo                                                | es_constante   | es_numerico_mal_tipo   |
|:------------------|:----------------------|:--------|-----------:|------------:|-----------:|:-------------------------------------------------------|:---------------|:-----------------------|
| Codigo            | codigo                | int64   |       1179 |        0    |       1179 | 1809839                                                | False          | False                  |
| IdSector          | idsector              | int64   |       1179 |        0    |          8 | 6                                                      | False          | False                  |
| NombreInstitucion | nombreinstitucion     | object  |       1179 |        0    |       1177 | ACADEMIA NACIONAL DE ESTUDIOS POLITICOS Y ESTRATEGICOS | False          | False                  |
| Sector            | sector                | object  |       1147 |        2.71 |          7 | Otros                                                  | False          | False                  |

## 5. Relaciones entre tablas y candidatos a claves

A partir de muestras representativas se han buscado columnas con nombres coincidentes entre LIC, OC y
el maestro de organismos, y se ha medido el solapamiento de valores únicos. Esto permite sugerir candidatos
a claves y relaciones para el modelo relacional.

### 5.1 Relación LIC ↔ OC

| columna         |   LIC_n_unicos |   OC_n_unicos |   interseccion |   ratio_interseccion |
|:----------------|---------------:|--------------:|---------------:|---------------------:|
| UnidadMedida    |             93 |            98 |             93 |               1      |
| FechaCreacion   |            581 |           717 |            572 |               0.9845 |
| sector          |              8 |             7 |              7 |               0.875  |
| CodigoProveedor |          46791 |         83481 |          34961 |               0.7472 |
| NombreProveedor |          46857 |         81798 |           8983 |               0.1917 |
| Nombre          |         126052 |       1627236 |           7286 |               0.0578 |
| Codigo          |         136123 |       2070139 |              0 |               0      |
| CodigoTipo      |              2 |             6 |              0 |               0      |
| Estado          |              6 |             5 |              0 |               0      |
| Link            |         136120 |       2070139 |              0 |               0      |
| Tipo            |             13 |             6 |              0 |               0      |
| __source_file   |             14 |            14 |              0 |               0      |

### 5.2 Relación LIC ↔ Organismos

| columna_comun   |   LIC_n_unicos |   ORG_n_unicos |   interseccion |   ratio_interseccion |
|:----------------|---------------:|---------------:|---------------:|---------------------:|
| CodigoOrganismo |           1087 |           1179 |              0 |                    0 |

- Número total de registros en LIC: **5,408,947**.
- Registros de LIC con código de organismo presente en el maestro: **0** (0.00%).

### 5.3 Relación OC ↔ Organismos

| columna_comun          |   OC_n_unicos |   ORG_n_unicos |   interseccion |   ratio_interseccion |
|:-----------------------|--------------:|---------------:|---------------:|---------------------:|
| CodigoOrganismoPublico |          1160 |           1179 |              0 |                    0 |

- Número total de registros en OC: **5,622,180**.
- Registros de OC con código de organismo presente en el maestro: **0** (0.00%).

## 7. Implicancias arquitectónicas y decisiones derivadas

A partir de las métricas observadas en los ficheros mensuales de Licitaciones (LIC) y Órdenes de Compra (OC),
se justifican una serie de decisiones arquitectónicas para el diseño del Data Lake y los procesos ETL del TFM.

En el periodo analizado se observa aproximadamente:

- **LIC**: 14 archivos mensuales, ~5,408,947 filas y ~8,696.01 MB.
- **OC**: 14 archivos mensuales, ~5,622,180 filas y ~9,028.80 MB.
- Volumen agregado aproximado: **11,031,127 filas** y **17,724.81 MB**.

| Problema observado                                              | Decisión tomada                                                                                         | Justificación                                                                                         |
|:----------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------|
| Volumen elevado y crecimiento mensual de LIC y OC               | Particionar el Data Lake en capas 01_RAW, 02_CLEAN, 03_MART, 04_METADATA con subdirectorios por año/mes | Permite cargas incrementales y reprocesos acotados a periodos, evitando releer el histórico completo. |
| Heterogeneidad de columnas (LIC ~105 columnas, OC ~78 columnas) | Normalización de esquemas en 02_CLEAN y modelado dimensional explícito en 03_MART                       | Facilita el diseño del modelo relacional en PostgreSQL y la explotación analítica posterior.          |
| Existencia de duplicados y posibles inconsistencias entre meses | Aplicar controles de deduplicación y registrar persistencia de filas entre periodos en 04_METADATA      | Documenta la calidad real del origen y permite decisiones explícitas de inclusión/exclusión.          |

## 8. Propuesta de modelo relacional y claves

A partir del análisis de columnas y de los solapamientos de valores entre licitaciones (LIC), órdenes de compra (OC)
y el maestro de organismos, se propone un modelo relacional de inspiración dimensional, con:

### 8.1 Tablas de hechos

- **fact_licitaciones**
  - Clave primaria técnica sugerida: `pk_fact_licitaciones` (entera, `GENERATED ALWAYS AS IDENTITY`).
  - Claves naturales relevantes: `Codigo` (código de licitación), `Codigoitem`, `CodigoOrganismo`, `CodigoProveedor`.
  - Claves foráneas esperadas:
    - `fk_organismo` → `dim_organismo(Codigo)`.
    - `fk_proveedor` → `dim_proveedor(CodigoProveedor)`.
    - `fk_producto` → `dim_producto(CodigoProductoONU)` (si está presente).
    - `fk_fecha` → `dim_fecha(fecha)` para fechas como creación, apertura o adjudicación.

- **fact_ordenes_compra**
  - Clave primaria técnica sugerida: `pk_fact_ordenes_compra`.
  - Claves naturales relevantes: `ID` (identificador numérico interno), `Codigo` (código externo de la OC).
  - Claves foráneas esperadas:
    - `fk_organismo` → `dim_organismo(Codigo)`, a partir de `CodigoOrganismoPublico`.
    - `fk_proveedor` → `dim_proveedor(CodigoProveedor)`.
    - `fk_fecha` → `dim_fecha(fecha)` para fechas de creación, aceptación, envío, etc.

### 8.2 Tablas de dimensiones

- **dim_organismo**
  - Clave primaria natural sugerida: `Codigo` (procedente del maestro de organismos).
  - Atributos: `NombreInstitucion`, `IdSector`, `Sector` (si está disponible), y otros atributos estables.

- **dim_proveedor**
  - Clave primaria natural sugerida: `CodigoProveedor`.
  - Atributos: razón social, comuna, actividad económica y otros campos disponibles en los reportes/licencias.

- **dim_producto**
  - Clave primaria natural sugerida: `CodigoProductoONU` (en el caso de LIC).
  - Atributos: descripción de la categoría ONU y posibles jerarquías de clasificación.

- **dim_fecha**
  - Clave primaria natural sugerida: `fecha` (tipo DATE).
  - Atributos: año, mes, día, trimestre, día de la semana, indicadores de calendario fiscal, etc.

En la implementación física en PostgreSQL se recomienda utilizar claves técnicas enteras en todas las tablas
y mantener las claves naturales como columnas de negocio con índices adicionales cuando se requieran búsquedas
por código. Este enfoque mejora el rendimiento y simplifica la gestión de cambios en los códigos de negocio.

## 9. Implicancias para orquestación y productivización

Dado que las descargas de LIC y OC se organizan en ficheros mensuales, con un total de
**14 ficheros LIC** y **14 ficheros OC** en el periodo analizado, la orquestación
de los procesos ETL se plantea siguiendo un enfoque **modular y repetible**, adecuado para su despliegue
en contenedores Docker y su coordinación mediante un orquestador como **n8n**.

### 9.1 Frecuencia de actualización sugerida

- Frecuencia principal: **carga mensual**, alineada con la publicación de los ficheros LIC y OC.
- Extensible a un esquema incremental si se automatiza la detección de nuevos meses disponibles.

### 9.2 Orden recomendado de tareas en el pipeline

1. Descarga de los ficheros CSV de LIC y OC para el mes objetivo.
2. Descompresión y almacenamiento en la capa **01_RAW** del Data Lake.
3. Validaciones básicas por archivo:
   - Número de columnas esperado.
   - Tipos mínimos de campos clave (códigos, fechas, montos).
4. Profiling opcional (como el que realiza este notebook) para actualizar métricas de calidad.
5. Normalización y limpieza en la capa **02_CLEAN**:
   - Homogeneización de tipos.
   - Tratamiento de nulos.
   - Deduplicación de registros.
6. Carga en PostgreSQL:
   - Población de tablas de staging.
   - Inserción en tablas de hechos y dimensiones en la capa **03_MART**.
7. Actualización de metadatos en **04_METADATA**:
   - Registro de ficheros procesados.
   - Incidencias detectadas (anomalías, cambios de esquema, etc.).

### 9.3 Checks automáticos recomendados

En cada ejecución mensual se sugiere incluir, al menos, los siguientes checks:

- Validación del número de columnas por archivo frente a una referencia histórica.
- Detección de cambios en el esquema (columnas nuevas o eliminadas).
- Comprobación de que el rango de filas está dentro de un intervalo razonable
  (comparando con meses anteriores para detectar caídas bruscas o crecimientos anómalos).
- Control del porcentaje máximo de nulos en columnas críticas (códigos de organismo, códigos de proveedor, montos).
- Detección de ficheros anómalos (por ejemplo, con muy pocas filas o columnas inesperadas).

| dataset   | file            |   rows |   n_columns | comentario                                                          |
|:----------|:----------------|-------:|------------:|:--------------------------------------------------------------------|
| LIC       | LIC_2025-01.csv |      2 |           1 | Archivo con muy pocas filas y/o columnas. Requiere revisión manual. |
| OC        | OC_2025-03.csv  |      2 |           1 | Archivo con muy pocas filas y/o columnas. Requiere revisión manual. |

Estos checks pueden implementarse como nodos de validación en n8n, generando logs estructurados
y, en caso necesario, alertas cuando se detecten desviaciones respecto a los umbrales definidos.

## 10. Comparación de fuentes de datos y decisión final

En ChileCompra coexisten varias formas de acceder a la información de licitaciones y órdenes de compra:

- **API de LIC/OC** (servicios web).
- **Formato OCDS** (Open Contracting Data Standard, típicamente JSON).
- **Descarga masiva de CSV** publicada en el portal de Datos Abiertos.

La siguiente tabla resume una comparación conceptual entre estas fuentes:

| Fuente              | Ventajas                                                                                 | Limitaciones                                                                    |
|:--------------------|:-----------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------|
| API LIC/OC          | Acceso programático, filtrado dinámico, actualización en línea.                          | Gestión de credenciales, límites de peticiones, posibles cambios de versión.    |
| Formato OCDS (JSON) | Estándar internacional de transparencia, estructura rica y extensible.                   | Esquemas complejos, necesidad de normalización adicional para análisis tabular. |
| Descarga masiva CSV | Esquema tabular directo, muchas columnas disponibles, integración natural con Data Lake. | Gran volumen de ficheros, gestión manual de versiones si no se automatiza.      |

Para este Trabajo Fin de Máster se ha optado por trabajar principalmente con la **descarga masiva de CSV** porque:

1. Los ficheros CSV mensuales proporcionan un esquema amplio de columnas, alineado con las necesidades analíticas del TFM.
2. La descarga masiva reduce la fricción operativa frente a la API (gestión de credenciales, límites de peticiones, cambios de versión).
3. El formato JSON OCDS, aunque muy relevante a efectos de transparencia, requiere un esfuerzo adicional de normalización
   para llegar a estructuras tabulares comparables a los reportes CSV utilizados.
4. El enfoque por ficheros CSV encaja de forma natural con una arquitectura de Data Lake particionado por año/mes,
   facilitando los procesos ETL en contenedores Docker.

Esta decisión no implica que la API ni el formato OCDS sean menos válidos en términos generales, sino que, para este proyecto
concreto, la opción de descarga masiva CSV ofrece un mejor equilibrio entre riqueza de datos, estabilidad del esquema
y simplicidad operativa.

## 11. Indicadores de alto nivel para contexto

A partir de los datos consolidados de licitaciones (LIC) y órdenes de compra (OC), se obtienen los siguientes
indicadores agregados preliminares:

- Número total de licitaciones (registros en LIC) en el periodo analizado: **5,408,947**.
- Número total de órdenes de compra (registros en OC) en el periodo analizado: **5,622,180**.
- Monto total aproximado de órdenes de compra (columna `MontoTotalOC`): **39,641,879,940,802.20**.
Además, se puede observar una evolución temporal del número de registros por fichero mensual.
Las tablas siguientes muestran el número de filas por archivo en LIC y en OC (ordenadas por nombre de fichero):

### 11.1 Evolución de registros en LIC por archivo

| file            |   rows |
|:----------------|-------:|
| LIC_2024-09.csv | 178091 |
| LIC_2024-10.csv | 219827 |
| LIC_2024-11.csv | 530356 |
| LIC_2024-12.csv | 359662 |
| LIC_2025-01.csv |      2 |
| LIC_2025-02.csv | 598982 |
| LIC_2025-03.csv | 554409 |
| LIC_2025-04.csv | 556771 |
| LIC_2025-05.csv | 538324 |
| LIC_2025-06.csv | 472003 |
| LIC_2025-07.csv | 432435 |
| LIC_2025-08.csv | 418350 |
| LIC_2025-09.csv | 312383 |
| LIC_2025-10.csv | 237352 |

### 11.2 Evolución de registros en OC por archivo

| file           |   rows |
|:---------------|-------:|
| OC_2024-09.csv | 396516 |
| OC_2024-10.csv | 508095 |
| OC_2024-11.csv | 470710 |
| OC_2024-12.csv | 411596 |
| OC_2025-01.csv | 360815 |
| OC_2025-02.csv | 354933 |
| OC_2025-03.csv |      2 |
| OC_2025-04.csv | 467832 |
| OC_2025-05.csv | 438074 |
| OC_2025-06.csv | 436932 |
| OC_2025-07.csv | 454386 |
| OC_2025-08.csv | 443201 |
| OC_2025-09.csv | 408749 |
| OC_2025-10.csv | 470339 |

Estos indicadores no pretenden ser un análisis definitivo, sino una primera fotografía cuantitativa que:

- Demuestra que se trabaja con volúmenes reales (no datos de juguete).
- Sirve como base para los paneles y dashboards que se construirán en fases posteriores del TFM.
- Permite ilustrar, en la memoria, el orden de magnitud de la actividad de compras públicas cubierta por la plataforma.

## 12. Calidad del dato y anomalías detectadas

El análisis detallado de los ficheros y de las columnas permite identificar una serie de anomalías
que tienen impacto directo en la calidad del dato y en las decisiones de ingeniería posteriores.

### 12.1 Anomalías a nivel de archivo

| dataset   | file            |   rows |   n_columns | severidad   | comentario                                                                                  |
|:----------|:----------------|-------:|------------:|:------------|:--------------------------------------------------------------------------------------------|
| LIC       | LIC_2025-01.csv |      2 |           1 | alta        | Muy pocas filas respecto al resto de meses. Número de columnas diferente al modo histórico. |
| OC        | OC_2025-03.csv  |      2 |           1 | alta        | Muy pocas filas respecto al resto de meses. Número de columnas diferente al modo histórico. |

### 12.2 Anomalías a nivel de columna

| dataset   | columna                    |   n_unicos | severidad   | comentario                                 |
|:----------|:---------------------------|-----------:|:------------|:-------------------------------------------|
| LIC       | Cantidad                   |       7243 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | Cantidad Ofertada          |       6687 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | CantidadAdjudicada         |       7421 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | DescripcionProveedor       |    1283971 | alta        | Cardinalidad extremadamente alta.          |
| LIC       | DireccionEntrega           |          1 | media       | Columna constante (sin variabilidad).      |
| LIC       | DireccionVisita            |          1 | media       | Columna constante (sin variabilidad).      |
| LIC       | EsBaseTipo                 |          1 | media       | Columna constante (sin variabilidad).      |
| LIC       | EsRenovable                |          1 | media       | Columna constante (sin variabilidad).      |
| LIC       | FechaEntregaAntecedentes   |          1 | media       | Columna constante (sin variabilidad).      |
| LIC       | FechaVisitaTerreno         |          1 | media       | Columna constante (sin variabilidad).      |
| LIC       | Monto Estimado Adjudicado  |      63627 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | MontoEstimado              |      42226 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | MontoLineaAdjudica         |     138127 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | MontoUnitarioOferta        |     343467 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | PeriodoTiempoRenovacion    |          0 | media       | Columna constante (sin variabilidad).      |
| LIC       | Valor Total Ofertado       |     481992 | media       | Posible numérico mal tipado (tipo object). |
| LIC       | ValorTiempoRenovacion      |          1 | media       | Columna constante (sin variabilidad).      |
| OC        | Cargos                     |       6874 | media       | Posible numérico mal tipado (tipo object). |
| OC        | Codigo                     |    2070139 | alta        | Cardinalidad extremadamente alta.          |
| OC        | Descripcion/Obervaciones   |    1709056 | alta        | Cardinalidad extremadamente alta.          |
| OC        | Descuentos                 |      11158 | media       | Posible numérico mal tipado (tipo object). |
| OC        | EspecificacionComprador    |    3644997 | alta        | Cardinalidad extremadamente alta.          |
| OC        | EspecificacionProveedor    |    2323086 | alta        | Cardinalidad extremadamente alta.          |
| OC        | ID                         |    2070139 | alta        | Cardinalidad extremadamente alta.          |
| OC        | IDItem                     |    5622175 | alta        | Cardinalidad extremadamente alta.          |
| OC        | Impuestos                  |     593277 | media       | Posible numérico mal tipado (tipo object). |
| OC        | Link                       |    2070139 | alta        | Cardinalidad extremadamente alta.          |
| OC        | MontoTotalOC               |     747027 | media       | Posible numérico mal tipado (tipo object). |
| OC        | MontoTotalOC_PesosChilenos |     754480 | media       | Posible numérico mal tipado (tipo object). |
| OC        | Nombre                     |    1627236 | alta        | Cardinalidad extremadamente alta.          |
| OC        | PorcentajeIva              |          7 | media       | Posible numérico mal tipado (tipo object). |
| OC        | PromedioCalificacion       |        456 | media       | Posible numérico mal tipado (tipo object). |
| OC        | TotalNetoOC                |     686289 | media       | Posible numérico mal tipado (tipo object). |
| OC        | cantidad                   |      26918 | media       | Posible numérico mal tipado (tipo object). |
| OC        | precioNeto                 |     487637 | media       | Posible numérico mal tipado (tipo object). |
| OC        | totalCargos                |        346 | media       | Posible numérico mal tipado (tipo object). |
| OC        | totalDescuentos            |        937 | media       | Posible numérico mal tipado (tipo object). |
| OC        | totalLineaNeto             |     710832 | media       | Posible numérico mal tipado (tipo object). |

Para cada anomalía se recomienda documentar explícitamente en la memoria del TFM:

- Qué se ha detectado.
- Hipótesis de causa (cambios de formato, incidencias operativas, campos informativos poco útiles, etc.).
- Decisión técnica provisional (incluir, excluir, transformar o tratar de forma especial).

Esta sección refuerza la idea de que la plataforma no solo consume datos, sino que también razona
sobre su calidad y sus limitaciones.

## 13. Tests de integridad y resumen para productivización

Para facilitar la futura productivización del pipeline, se han definido una serie de tests de integridad
que pueden ejecutarse de forma automática en cada carga mensual.

### 13.1 Umbrales de nulos en columnas críticas (LIC)

| columna         | existe   |   pct_nulos |   max_pct_nulos | ok   | comentario   |
|:----------------|:---------|------------:|----------------:|:-----|:-------------|
| CodigoOrganismo | True     |        0    |               5 | True |              |
| CodigoProveedor | True     |        0.89 |              20 | True |              |

### 13.2 Umbrales de nulos en columnas críticas (OC)

| columna                | existe   |   pct_nulos |   max_pct_nulos | ok   | comentario   |
|:-----------------------|:---------|------------:|----------------:|:-----|:-------------|
| CodigoOrganismoPublico | True     |           0 |               5 | True |              |
| CodigoProveedor        | True     |           0 |              20 | True |              |

### 13.3 Umbrales de duplicados por archivo (LIC)

| file            |   rows |   dup_rows |   dup_pct | ok   | comentario   |
|:----------------|-------:|-----------:|----------:|:-----|:-------------|
| LIC_2025-02.csv | 598982 |      62975 |   10.5137 | True |              |
| LIC_2024-11.csv | 530356 |       9602 |    1.8105 | True |              |
| LIC_2024-12.csv | 359662 |       4905 |    1.3638 | True |              |
| LIC_2025-08.csv | 418350 |       4231 |    1.0114 | True |              |
| LIC_2025-03.csv | 554409 |       5220 |    0.9415 | True |              |
| LIC_2025-10.csv | 237352 |       1633 |    0.688  | True |              |
| LIC_2025-06.csv | 472003 |       2597 |    0.5502 | True |              |
| LIC_2025-05.csv | 538324 |       2633 |    0.4891 | True |              |
| LIC_2025-04.csv | 556771 |       1887 |    0.3389 | True |              |
| LIC_2025-09.csv | 312383 |       1030 |    0.3297 | True |              |
| LIC_2025-07.csv | 432435 |       1181 |    0.2731 | True |              |
| LIC_2024-09.csv | 178091 |        192 |    0.1078 | True |              |
| LIC_2024-10.csv | 219827 |        236 |    0.1074 | True |              |
| LIC_2025-01.csv |      2 |          0 |    0      | True |              |

### 13.4 Umbrales de duplicados por archivo (OC)

| file           |   rows |   dup_rows |   dup_pct | ok   | comentario   |
|:---------------|-------:|-----------:|----------:|:-----|:-------------|
| OC_2024-09.csv | 396516 |          0 |         0 | True |              |
| OC_2024-10.csv | 508095 |          0 |         0 | True |              |
| OC_2024-11.csv | 470710 |          0 |         0 | True |              |
| OC_2024-12.csv | 411596 |          0 |         0 | True |              |
| OC_2025-01.csv | 360815 |          0 |         0 | True |              |
| OC_2025-02.csv | 354933 |          0 |         0 | True |              |
| OC_2025-03.csv |      2 |          0 |         0 | True |              |
| OC_2025-04.csv | 467832 |          0 |         0 | True |              |
| OC_2025-05.csv | 438074 |          0 |         0 | True |              |
| OC_2025-06.csv | 436932 |          0 |         0 | True |              |
| OC_2025-07.csv | 454386 |          0 |         0 | True |              |
| OC_2025-08.csv | 443201 |          0 |         0 | True |              |
| OC_2025-09.csv | 408749 |          0 |         0 | True |              |
| OC_2025-10.csv | 470339 |          0 |         0 | True |              |

En una implantación real, estos tests se implementarían como funciones reutilizables en el contenedor `tfm-etl`,
de forma que cualquier ejecución del pipeline deje un rastro de logs estructurados y, en caso necesario,
dispare alertas cuando se incumplan los umbrales definidos.

## 14. Próximos pasos en el TFM

A partir de este resumen maestro, los siguientes pasos en el Trabajo Fin de Máster serán:

1. Detallar y refinar el modelo conceptual y lógico (dimensiones, hechos, claves técnicas).
2. Implementar los procesos ETL en Python dentro del contenedor `tfm-etl`, utilizando las decisiones de calidad
   y los tests de integridad aquí definidos.
3. Cargar los datos consolidados en PostgreSQL, siguiendo el modelo relacional propuesto.
4. Construir paneles analíticos y los indicadores clave para el análisis de compras públicas.
5. Integrar la ejecución recurrente de estos procesos en un flujo orquestado con n8n y contenedores Docker.
6. Explorar la integración de un asistente de IA que aproveche tanto el modelo de datos como los metadatos
   de calidad y los logs de ejecución del pipeline.
