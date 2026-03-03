# Diccionario operativo – LIC

> Generado automáticamente. Orientado a STAGING (PostgreSQL): tipos sugeridos y llaves candidatas.

| columna | presencia_archivos | null_pct_global | tipo_sugerido | ejemplos |
|---|---:|---:|---|---|
| Cantidad | 13 | 0.00% | BIGINT | 60; 1; 50; 540000 |
| Cantidad Ofertada | 13 | 62.50% | BIGINT | 60; 1; 50; 540000 |
| CantidadAdjudicada | 13 | 62.51% | BIGINT | 0; 1; 50; 540000 |
| CantidadReclamos | 13 | 0.00% | BIGINT | 185; 550; 1202; 2322 |
| Codigo | 13 | 0.00% | BIGINT | 9291266; 9187233; 9287667; 9289201 |
| CodigoEstado | 13 | 0.00% | BIGINT | 7; 8; 6; 15 |
| CodigoEstadoLicitacion | 13 | 0.00% | BIGINT | 7; 8; 6; 15 |
| CodigoExterno | 13 | 0.00% | TEXT | 2563-1-LR24; 5184-128-LR23; 5056-104-LP23; 2111-3-LQ24 |
| CodigoMoneda | 13 | 0.00% | TEXT | CLP |
| CodigoOrganismo | 13 | 0.00% | BIGINT | 7202; 7258; 7260; 7460 |
| CodigoProductoONU | 13 | 0.00% | BIGINT | 83111601; 41116130; 84101704; 42142715 |
| CodigoProveedor | 13 | 0.89% | BIGINT | 21214; 41738; 44544; 46868 |
| CodigoSucursalProveedor | 13 | 0.89% | BIGINT | 20628; 42456; 45405; 47841 |
| CodigoTipo | 13 | 0.00% | BIGINT | 1 |
| CodigoUnidad | 13 | 0.00% | BIGINT | 3554; 6097; 5969; 3106 |
| Codigoitem | 13 | 0.00% | BIGINT | 41607456; 41607457; 41607458; 41122940 |
| ComunaUnidad | 13 | 9.23% | TEXT | Providencia; Linares; Talca; Santiago |
| Contrato | 13 | 6.52% | BIGINT | 0; 2 |
| Correlativo | 13 | 0.00% | BIGINT | 1; 2; 3; 4 |
| Descripcion | 13 | 0.00% | TEXT | La Direccin General de Aeronutica Civil, llama a propuesta pblica para la contratacin de los servicios de infraestructur |
| Descripcion linea Adquisicion | 13 | 0.27% | TEXT | COMPONENTE 1 ENLACES RED WAN IP-MPLS, SD-WAN Y ACCESO A INTERNET; COMPONENTE 2: Seguridad de Red Perimetral y NG-AV; COM |
| DescripcionProveedor | 13 | 62.51% | TEXT | valor neto mensual; FORMULARIO ECONMICO COMPONENTE ENLACES RED WAN IP-MPLS, SD-WAN Y ACCESO A INTERNET; COMPONENTE 2: Se |
| DireccionEntrega | 13 | 0.00% | TEXT | 1900-01-01 |
| DireccionUnidad | 13 | 8.59% | TEXT | Miguel Claro 1314; Brasil N 753; 1 Norte N 1990; Curico N345 Bodega Central |
| DireccionVisita | 13 | 0.00% | TEXT | 1900-01-01 |
| EsBaseTipo | 13 | 0.00% | BIGINT | 0 |
| EsRenovable | 13 | 0.00% | BIGINT | 0 |
| Estado | 13 | 0.00% | TEXT | Desierta (o art. 3  9 Ley 19.886); Adjudicada; Cerrada; Revocada |
| Estado Oferta | 13 | 0.00% | TEXT | Aceptada; Rechazada |
| EstadoCS | 13 | 0.00% | BIGINT | 1; 0; 5 |
| EstadoEtapas | 13 | 0.00% | BIGINT | 1; 0; 2 |
| EstadoPublicidadOfertas | 13 | 0.00% | BIGINT | 1 |
| Estimacion | 13 | 0.32% | BIGINT | 2; 1 |
| Etapas | 13 | 0.00% | BIGINT | 1; 2 |
| ExtensionPlazo | 13 | 0.00% | BIGINT | 0; 1 |
| FechaActoAperturaEconomica | 13 | 0.00% | TIMESTAMP | 2024-12-10; 2024-11-20; 2024-11-15; 2024-10-18 |
| FechaActoAperturaTecnica | 13 | 0.00% | TIMESTAMP | 2024-12-10; 2024-11-20; 2024-11-15; 2024-10-18 |
| FechaAdjudicacion | 13 | 0.00% | TIMESTAMP | 2025-01-29; 2025-02-14; 2024-12-10; 2024-12-02 |
| FechaAprobacion | 13 | 17.10% | TIMESTAMP | 2024-10-28; 2024-12-03; 2024-12-05; 2025-02-14 |
| FechaCierre | 13 | 0.00% | TIMESTAMP | 2024-12-09; 2024-11-20; 2024-11-15; 2024-10-18 |
| FechaCreacion | 13 | 0.00% | TIMESTAMP | 2024-01-08; 2023-06-19; 2023-12-27; 2024-01-02 |
| FechaEntregaAntecedentes | 13 | 0.00% | TEXT | 1900-01-01 |
| FechaEnvioOferta | 13 | 0.89% | TIMESTAMP | 2024-12-09; 2024-11-20; 2024-11-15; 2024-10-18 |
| FechaEstimadaAdjudicacion | 13 | 0.00% | TIMESTAMP | 2025-04-16; 2024-12-31; 2024-12-11; 2024-11-18 |
| FechaEstimadaFirma | 13 | 0.00% | TIMESTAMP | 2025-06-16; 1900-01-01; 2024-04-16; 2024-12-24 |
| FechaFinal | 13 | 0.00% | TIMESTAMP | 2024-10-04; 2024-11-07; 2024-11-04; 2024-10-11 |
| FechaInicio | 13 | 0.00% | TIMESTAMP | 2024-09-09; 2024-10-18; 2024-10-30; 2024-10-07 |
| FechaPubRespuestas | 13 | 0.00% | TIMESTAMP | 2024-10-18; 2024-11-11; 2024-11-07; 2024-10-14 |
| FechaPublicacion | 13 | 0.00% | TIMESTAMP | 2024-09-09; 2024-10-18; 2024-10-30; 2024-10-07 |
| FechaSoporteFisico | 13 | 0.00% | TIMESTAMP | 2024-12-09; 1900-01-01; 2025-09-23 |
| FechaTiempoEvaluacion | 13 | 0.00% | BIGINT | 14; 0; 30; 20 |
| FechaVisitaTerreno | 13 | 0.00% | TEXT | 1900-01-01 |
| FechasUsuario | 13 | 0.00% | BIGINT | 9; 1; 0; 2 |
| FuenteFinanciamiento | 13 | 41.74% | TEXT | DGAC - Recursos Propios; HOSPITAL DE LINARES; HUAP; Municipal |
| Informada | 13 | 0.00% | BIGINT | 0 |
| JustificacionMontoEstimado | 13 | 69.05% | TEXT | 0; 1; La presente contratacin ser financiada con presupuesto del Complejo Asistencial Dr. Vctor Ros Ruiz, Los ngeles, co |
| JustificacionPublicidad | 13 | 93.39% | TEXT | Todas las ofertas tcnicas sern visibles al pblico en general, travs del portal www.mercadopublico.cl, desde el momento d |
| Link | 13 | 0.00% | TEXT | http://www.mercadopublico.cl/fichaLicitacion.html?idLicitacion=2563-1-LR24; http://www.mercadopublico.cl/fichaLicitacion |
| Modalidad | 13 | 0.00% | TEXT | RFB_CONTRACT_PAYMENT_METHOD_30_DAYS; RFB_CONTRACT_PAYMENT_METHOD_OTHERS |
| Moneda Adquisicion | 13 | 0.00% | TEXT | Peso Chileno |
| Moneda de la Oferta | 13 | 0.00% | TEXT | Peso Chileno; Moneda revisar |
| Monto Estimado Adjudicado | 13 | 13.49% | BIGINT | 1480000; 1338995; 133623000; 419828000 |
| MontoEstimado | 13 | 0.82% | TEXT | 1e+10; 4e+08; 64700000; 308845000 |
| MontoLineaAdjudica | 13 | 62.51% | NUMERIC | 0; 419828000; 1,83; 24357,18 |
| MontoUnitarioOferta | 13 | 62.50% | NUMERIC | 105312159,76; 142464823; 49628075,54; 31623395 |
| Nombre | 13 | 0.00% | TEXT | Infraestructura Crtica de Comunicaciones; REACTIVOS IDENTIFICACIN Y SENSIBILIDAD BACTERIANA; Servicio pagos electrnicos  |
| Nombre de la Oferta | 13 | 0.89% | TEXT | Licitacion red WAN Infraestructura Crtica de Comunicaciones; Propuesta ENTEL S.A. Servicios de Infraestructura Crtica; 5 |
| Nombre linea Adquisicion | 13 | 0.00% | TEXT | Servicio de redes para mejorar la seal de telecomunicaciones; Reactivos, soluciones o tinturas microbiolgicos o bacterio |
| Nombre producto genrico | 13 | 0.00% | TEXT | SERVICIO DE REDES PARA MEJORAR LA SEAL DE TELECOMUNICACIONES; REACTIVOS, SOLUCIONES O TINTURAS MICROBIOLGICOS O BACTERIO |
| NombreOrganismo | 13 | 0.00% | TEXT | DIRECCION GENERAL DE AERONAUTICA CIVIL; SERVICIO DE SALUD DEL MAULE HOSPITAL DE LINARES; SERVICIO DE SALUD DEL MAULE HOS |
| NombreProveedor | 13 | 0.89% | TEXT | TELEFONICA EMPRESAS CHILE SA; ENTEL CHILE S.A.; GALENICA S.A.; TRANSBANK S.A. - Casa Matriz |
| NombreUnidad | 13 | 0.00% | TEXT | UNIDAD DE COMPRA CONTRATOS NACIONALES; CONTRATOS-SUMINISTRO; Servicios; Hospital de Urgencia Asistencia Pblica |
| NumeroAprobacion | 13 | 17.11% | BIGINT | 176; 9649; 1056; 049 |
| NumeroOferentes | 13 | 0.00% | BIGINT | 2; 1; 5; 4 |
| Obras | 13 | 0.00% | BIGINT | 0; 2 |
| ObservacionContrato | 13 | 77.95% | TEXT | Monto referencial incluye impuestos.; ver bases; PRESUPUESTO CONSIDERA VALOR TOTAL IMPUESTOS INCLUIDOS.; MONTO DISPONIBL |
| Oferta seleccionada | 13 | 0.00% | TEXT | No Seleccionada; Seleccionada |
| PeriodoTiempoRenovacion | 13 | 100.00% | TEXT |  |
| ProhibicionContratacion | 13 | 74.39% | TEXT | En todo evento el adjudicado es el responsable de todas las obligaciones contradas con la Municipalidad en virtud del co |
| RazonSocialProveedor | 13 | 0.89% | TEXT | TELEFONICA EMPRESAS CHILE SA; EMPRESA NACIONAL DE TELECOMUNICACIONES S A; GALENICA S.A.; TRANSBANK S A |
| RegionUnidad | 13 | 0.00% | TEXT | Regin Metropolitana de Santiago; Regin del Maule ; Regin de Valparaso ; Regin de Coquimbo  |
| Rubro1 | 13 | 0.00% | TEXT | SERVICIOS BSICOS Y DE INFORMACIN PBLICA; EQUIPAMIENTO PARA LABORATORIOS; SERVICIOS FINANCIEROS, PENSIONES Y SEGUROS; EQU |
| Rubro2 | 13 | 0.00% | TEXT | TELECOMUNICACIONES; INSTRUMENTOS DE MEDIDA Y EXPERIMENTACIN; FINANZAS PARA EL DESARROLLO; SUMINISTROS Y PRODUCTOS CLNICO |
| Rubro3 | 13 | 0.00% | TEXT | COMUNICACIONES MVILES; KITS PARA ENSAYOS MANUALES, CONTROLES DE CALIDAD, CALIBRADORES Y NORMATIVAS; GESTIN DE DEUDAS; SU |
| RutProveedor | 13 | 0.89% | TEXT | 78.703.410-1; 92.580.000-7; 79.622.060-0; 96.689.310-9 |
| RutUnidad | 13 | 0.00% | TEXT | 61.104.000-8; 61.606.917-9; 61.606.901-2; 61.608.602-2 |
| SubContratacion | 13 | 0.00% | BIGINT | 0; 1 |
| Tiempo | 13 | 54.38% | BIGINT | 60; 48; 36; 12 |
| TiempoDuracionContrato | 13 | 0.00% | BIGINT | 60; 48; 36; 12 |
| Tipo | 13 | 0.00% | TEXT | LR; LP; LQ; LE |
| Tipo de Adquisicion | 13 | 0.00% | TEXT | Licitacin Pblica Mayor a 5000 (LR); Licitacin Pblica Mayor 1000 UTM (LP); Licitacin Pblica entre a 2000 y 5000 UTM (LQ); |
| TipoAprobacion | 13 | 17.10% | BIGINT | 2; 4 |
| TipoConvocatoria | 13 | 0.00% | BIGINT | 1; 0 |
| TipoDuracionContrato | 13 | 99.69% | TEXT | RFB_CONTRACT_TIME_PERIOD_INMEDIATE_EXECUTION; RFB_CONTRACT_TIME_PERIOD_ALONG_TIME_EXECUTION |
| TipoPago | 13 | 0.00% | BIGINT | 1; 4; 2 |
| TomaRazon | 13 | 0.00% | BIGINT | 0; 1 |
| UnidadMedida | 13 | 0.00% | TEXT | Mes; Global; Unidad; Kit |
| UnidadTiempo | 13 | 0.00% | TEXT | RFB_TIME_PERIOD_DAYS; RFB_TIME_PERIOD_HOURS; -1 |
| UnidadTiempoContratoLicitacion | 13 | 0.00% | BIGINT | 2; 1 |
| UnidadTiempoDuracionContrato | 13 | 0.00% | BIGINT | 4; 2; 1 |
| UnidadTiempoEvaluacion | 13 | 1.40% | TEXT | RFB_TIME_PERIOD_DAYS; RFB_TIME_PERIOD_HOURS |
| Valor Total Ofertado | 13 | 62.50% | NUMERIC | 6318729585,6; 8547889380; 2977684532,4; 1897403700 |
| ValorTiempoRenovacion | 13 | 0.00% | BIGINT | 0 |
| VisibilidadMonto | 13 | 0.00% | BIGINT | 0; 1 |
| descripcion | 1 | 0.00% | TEXT | Compra de notebooks; Servicio de mantención |
| fechacierre | 1 | 0.00% | TEXT | 10-01-2025; 20-01-2025 |
| fechapublicacion | 1 | 0.00% | TEXT | 01-01-2025; 05-01-2025 |
| id_licitacion | 1 | 0.00% | BIGINT | 12345; 67890 |
| sector | 13 | 1.58% | TEXT | Gob. Central, Universidades; Salud; Obras Pblicas; Municipalidades |