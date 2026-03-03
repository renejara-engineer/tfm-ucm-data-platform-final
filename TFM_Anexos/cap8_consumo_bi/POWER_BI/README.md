# TFM — Diseño e implementación de un sistema ETL automatizado para la integración y análisis de datos abiertos de contratación pública

## Capítulo 8 — Consumo Analítico y Evidencia BI

## 1. Objetivo del módulo

El módulo BI materializa el contrato analítico definido en la capa semántica (`dw_sem`) del Data Warehouse, garantizando que las visualizaciones derivan exclusivamente de estructuras gobernadas y validadas.

Su función no es transformar datos ni reinterpretarlos, sino actuar como capa de evidencia analítica reproducible.

---

## 2. Rol dentro de la arquitectura global

El módulo se ubica al final del pipeline:

ETL → STG → DW → SEM → BI (Capa de Validación)

Power BI consume únicamente vistas semánticas y no accede a:

- Datos RAW  
- Tablas STG  
- Transformaciones intermedias  

Esto asegura separación de responsabilidades y cumplimiento de gobernanza.

---

## 3. Descripción de Paneles Implementados

El módulo BI se compone de un conjunto de paneles diseñados para validar, visualizar y evidenciar el comportamiento estructural del Data Warehouse. Cada panel responde a un objetivo analítico específico y se integra dentro del marco de gobernanza definido en capítulos anteriores.

---

### 3.1 MENÚ — Navegación estructurada

Panel de acceso general al modelo analítico.

Función:

- Organizar el recorrido lógico del dashboard.
- Separar dominios analíticos (LIC, OC, Cruces, Diagnóstico).
- Evitar navegación arbitraria.

---

### 3.2 INSTRUCCIONES — Marco metodológico

Establece reglas de interpretación:

- Periodo analizado (2024-09 a 2025-10).
- Restricción de segmentación monetaria.
- Naturaleza descriptiva del análisis.
- Limitaciones institucionales.

---

### 3.3 LIC — Validación estructural de licitaciones

Indicadores:

- Conteo de licitaciones distintas.
- Montos estimados y adjudicados por moneda.
- Proveedores distintos.
- Códigos ONU distintos.

Valida integridad del hecho de licitaciones.

---

### 3.4 Estados LIC–OC — Diagnóstico administrativo

Visualiza distribución por estado administrativo de LIC y OC.

Permite observar proporciones estructurales sin evaluación institucional.

---

### 3.5 OC — Análisis de Órdenes de Compra

Dimensiones:

- Periodo
- Organismo comprador
- Proveedor
- Producto ONU
- Moneda

Valida magnitudes estructurales de ejecución administrativa.

---

### 3.6 CRUCE_COD — Cruce estricto por código

Une `codigoexterno` (LIC) con `codigolicitacion` (OC).

Permite evaluar coincidencia administrativa estricta.

---

### 3.7 DT_TEND — Diagnóstico temporal

Evalúa:

- % LIC con OC asociada.
- % OC con LIC asociada.
- Medianas de densidad de cruce.

Valida estabilidad longitudinal.

---

### 3.8 DT_SECT — Diagnóstico sectorial

Analiza:

- Volumen por sector.
- Composición monetaria.
- Cobertura institucional.

---

### 3.9 NO_CRUCE — Muestra diagnóstica

Presenta casos sin coincidencia estricta de código.

Evidencia limitaciones de identificadores administrativos.

---

### 3.10 RECON — Validación inicial (Gate BI-1)

Verifica:

- Totales DW vs BI.
- Consistencia agregada básica.

Panel probatorio, no analítico.

---

### 3.11 Hallazgos y Limitaciones

Documenta:

- Restricciones del dato público.
- Limitaciones estructurales.
- Alcance descriptivo del sistema.

---

## 4. Principios metodológicos

- SQL como fuente primaria de verdad.
- BI como capa de evidencia.
- Separación estricta LIC / OC.
- No conversión de moneda.
- Validación cruzada obligatoria DW ↔ BI.

---

## 5. Cierre

El módulo BI evidencia coherencia estructural end-to-end del sistema, consolidando la validación analítica final del TFM.
