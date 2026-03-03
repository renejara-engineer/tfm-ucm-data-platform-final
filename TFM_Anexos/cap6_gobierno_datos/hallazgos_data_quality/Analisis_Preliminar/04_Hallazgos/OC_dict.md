# Diccionario operativo – OC

> Generado automáticamente. Orientado a STAGING (PostgreSQL): tipos sugeridos y llaves candidatas.

| columna | presencia_archivos | null_pct_global | tipo_sugerido | ejemplos |
|---|---:|---:|---|---|
| ActividadComprador | 13 | 22.48% | TEXT | Servicio Pblico; -; GOBIERNO CENTRAL Y ADMINISTRACION PUBLICA; Salud |
| ActividadProveedor | 13 | 0.86% | TEXT | OBRAS MENORES EN CONSTRUCCION (CONTRATISTAS, ALBAN; VENTA AL POR MAYOR DE OTROS PRODUCTOS N.C.P.| VENT; PREPARACION DEL  |
| CantidadEvaluacion | 13 | 0.00% | BIGINT | 0; 92; 3; 1 |
| Cargos | 13 | 0.00% | BIGINT | 0 |
| Categoria | 13 | 14.21% | TEXT | Servicios de construccin y mantenimiento / Construccin de edificios en general / Construccin de obras civiles y infraest |
| CiudadUnidadCompra | 13 | 1.75% | TEXT | Camarones; Maip; Copiap; Iquique |
| Codigo | 13 | 0.00% | TEXT | 5858-14-SE22; 5858-33-SE22; 1057472-8231-SE22; 1552-17-SE23 |
| CodigoAbreviadoTipoOC | 13 | 0.00% | TEXT | SE; AG |
| CodigoLicitacion | 13 | 64.15% | TEXT | 5858-1-LE22; 5858-2-LE22; 1057472-107-LE22; 1057539-161-LE22 |
| CodigoOrganismoPublico | 13 | 0.00% | BIGINT | 294421; 1379869; 7409; 7246 |
| CodigoProveedor | 13 | 0.00% | BIGINT | 287333; 1235540; 71801; 16120 |
| CodigoSucursal | 13 | 0.00% | BIGINT | 293454; 632295; 74074; 127487 |
| CodigoTipo | 13 | 0.00% | BIGINT | 8; 13 |
| CodigoUnidadCompra | 13 | 0.00% | BIGINT | 300526; 1057472; 2548; 2259 |
| Codigo_ConvenioMarco | 13 | 85.78% | TEXT | 2239-9-LR22; 2239-13-LR23; 2239-9-LR23; 2239-3-LR23 |
| ComunaProveedor | 13 | 14.76% | TEXT | Arica; Providencia; La Serena; Antofagasta |
| Descripcion/Obervaciones | 13 | 0.12% | TEXT | Mejoramiento de Infraestructura Sanitaria DESDE 5858-1-LE22; Construccin de casetas sanitarias Camarones DESDE 5858-2-LE |
| DescripcionTipoOC | 13 | 0.00% | TEXT | Sin emisin automtica; Compra gil |
| Descuentos | 13 | 0.00% | BIGINT | 0; 2711 |
| EsCompraAgil | 13 | 0.00% | TEXT | No; Si |
| EsTratoDirecto | 13 | 15.01% | TEXT | No; Si |
| EspecificacionComprador | 13 | 1.53% | TEXT | Instalacin de cinco soluciones individuales de alcantarillado, con tratamiento de aguas mediante fosa sptica y pozo abso |
| EspecificacionProveedor | 13 | 32.46% | TEXT |  Mejoramiento de Infraestructura Sanitaria; Construccin de casetas sanitarias Camarones; VALIDEZ DE LA OFERTA 120 DAS; O |
| Estado | 13 | 0.00% | TEXT | Aceptada; Recepcion Conforme; Enviada a proveedor; En proceso |
| EstadoProveedor | 13 | 0.00% | TEXT | Aceptada; Recepcion Conforme; Nueva orden de compra; En proceso |
| FechaAceptacion | 13 | 1.90% | TIMESTAMP | 2024-09-23; 2024-09-16; 2024-10-17; 2024-09-30 |
| FechaCancelacion | 13 | 100.00% | TIMESTAMP | 2024-09-03; 2024-09-09; 2024-10-16; 2024-10-28 |
| FechaCreacion | 13 | 0.00% | TIMESTAMP | 2022-05-12; 2022-09-22; 2022-10-12; 2023-01-10 |
| FechaEnvio | 13 | 0.00% | TIMESTAMP | 2024-09-23; 2024-09-16; 2024-09-26; 2024-09-27 |
| FechaSolicitudCancelacion | 13 | 3.45% | TIMESTAMP | 2024-09-23; 2024-09-13; 2024-09-26; 2024-09-27 |
| Financiamiento | 13 | 36.63% | TEXT | 3190; 26518; SECTOR; 22 |
| Forma de Pago | 13 | 1.28% | TEXT | Otro, Ver Instrucciones; 30 dias contra la recepcion conforme de la factura |
| FormaPago | 13 | 0.00% | BIGINT | 39; 2 |
| ID | 13 | 0.00% | BIGINT | 45885078; 46684778; 46800846; 47403642 |
| IDItem | 13 | 0.00% | BIGINT | 122139702; 124399739; 124726039; 126407219 |
| Impuestos | 13 | 0.00% | NUMERIC | 7821043,72; 4623807,32; 372400; 487567941,21 |
| Link | 13 | 0.00% | TEXT | http://www.mercadopublico.cl/PurchaseOrder/Modules/PO/DetailsPurchaseOrder.aspx?codigoOC=5858-14-SE22; http://www.mercad |
| MontoTotalOC | 13 | 0.00% | NUMERIC | 48984431,72; 28959635,32; 2332400; 3053715000,21 |
| MontoTotalOC_PesosChilenos | 13 | 0.00% | NUMERIC | 48984431,72; 28959635,32; 2332400; 3053715000,21 |
| Nombre | 13 | 0.00% | TEXT | ORDEN DE COMPRA DESDE 5858-1-LE22; ORDEN DE COMPRA DESDE 5858-2-LE22; ORDEN DE COMPRA DESDE 1057472-107-LE22; EJECUCION  |
| NombreProveedor | 13 | 0.00% | TEXT | CLAUDIA ANDREA MAUREIRA AHUMADA; WS AUDIOLOGY CHILE SPA; INMOBILIARIA E INVERSIONES QUILODRAN LTDA.; EMPRESA DE CORREOS  |
| NombreroductoGenerico | 13 | 0.00% | TEXT | Construccin de obras civiles; Audfonos para personas con discapacidad fsica; Servicios de transporte regional o nacional |
| OrganismoPublico | 13 | 0.00% | TEXT | Ilustre Municipalidad de Camarones; HOSPITAL CLINICO METROPOLITANO EL CARMEN DOCTOR LUIS VALENTIN FERRADA; SERVICIO DE S |
| Pais | 13 | 3.61% | TEXT | CL;   ; Extranjero |
| PaisProveedor | 13 | 49.56% | TEXT | Chile |
| PaisUnidadCompra | 13 | 3.61% | TEXT | CL;   ; Extranjero |
| PorcentajeIva | 13 | 0.00% | BIGINT | 19; 0; 13 |
| ProcedenciaOC | 13 | 15.01% | TEXT | Proveniente de licitacin pblica; licitacin pblica previa sin ofertas, o con ofertas inadmisibles; Orden de Compra para i |
| PromedioCalificacion | 13 | 0.00% | NUMERIC | 0; 4; 5; 3,4 |
| RegionProveedor | 13 | 15.45% | TEXT | Regin de Arica y Parinacota; Regin Metropolitana de Santiago; Regin de Coquimbo ; Regin de Antofagasta  |
| RegionUnidadCompra | 13 | 1.74% | TEXT | Regin de Arica y Parinacota; Regin Metropolitana de Santiago; Regin de Atacama ; Regin de Tarapac   |
| RubroN1 | 13 | 14.21% | TEXT | Servicios de construccin y mantenimiento; Equipamiento y suministros mdicos; Servicios de transporte, almacenaje y corre |
| RubroN2 | 13 | 14.21% | TEXT | Construccin de edificios en general; Ayuda para personas con discapacidad; Transporte de correo y carga; Servicios de re |
| RubroN3 | 13 | 14.21% | TEXT | Construccin de obras civiles y infraestructuras; Artculos de ayuda para la comunicacin de discapacitados; Transporte de  |
| RutSucursal | 13 | 0.04% | TEXT | 15.084.723-0; 76.136.334-4; 77.193.770-5; 60.503.000-9 |
| RutUnidadCompra | 13 | 0.00% | TEXT | 69.251.000-3; 61.980.320-5; 61.606.300-6; 61.202.000-0 |
| Sucursal | 13 | 0.09% | TEXT | maclau; WS AUDIOLOGY CHILE SPA; INMOBILIARIA E INVERSIONES QUILODRAN LTDA.; EMPRESA DE CORREOS DE CHILE - Gerencia Zonal |
| Tipo | 13 | 0.00% | TEXT | SE; AG |
| TipoDespacho | 13 | 0.00% | BIGINT | 12; 7; 22; 9 |
| TipoImpuesto | 13 | 0.00% | TEXT | IVA; Exento; Honorarios (13%) |
| TipoMonedaOC | 13 | 0.00% | TEXT | CLP; UTM; USD; CLF |
| TotalNetoOC | 13 | 0.00% | BIGINT | 41163388; 24335828; 1960000; 2566147059 |
| UnidadCompra | 13 | 0.00% | TEXT | Unidad Tcnica; Bienes y Servicios; Servicio de Salud Atacama; Direccin de Obras Portuarias - Iquique |
| UnidadMedida | 13 | 14.22% | TEXT | Unidad; Unidad no definida; Mes; Frasco Ampolla |
| cantidad | 13 | 0.00% | BIGINT | 1; 2; 36; 10 |
| codigoCategoria | 13 | 14.21% | BIGINT | 72131700; 42211700; 78101800; 80111700 |
| codigoEstado | 13 | 0.00% | BIGINT | 6; 12; 4; 5 |
| codigoEstadoProveedor | 13 | 0.00% | BIGINT | 4; 7; 1; 2 |
| codigoProductoONU | 13 | 0.00% | BIGINT | 72131702; 42211705; 78101802; 80111701 |
| fechaUltimaModificacion | 13 | 0.00% | TIMESTAMP | 2024-09-23; 2024-09-13; 2025-07-22; 2024-09-27 |
| monedaItem | 13 | 0.00% | TEXT | CLP; UTM; USD; CLF |
| precioNeto | 13 | 0.00% | BIGINT | 41163388; 24335828; 980000; 2566147059 |
| sector | 13 | 1.41% | TEXT | Municipalidades; Salud; Obras Pblicas; Gob. Central, Universidades |
| tieneItems | 13 | 0.00% | BIGINT | 1 |
| totalCargos | 13 | 0.00% | BIGINT | 0 |
| totalDescuentos | 13 | 0.00% | BIGINT | 0 |
| totalImpuestos | 13 | 44.11% | BIGINT | 0 |
| totalLineaNeto | 13 | 0.00% | BIGINT | 41163388; 24335828; 1960000; 2566147059 |
| x | 1 | 0.00% | TEXT | 42000 927 [Microsoft][ODBC SQL Server Driver][SQL Server]Database 'DCCPPlatform' cannot be opened. It is in the middle o |