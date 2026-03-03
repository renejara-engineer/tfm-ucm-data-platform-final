# Auditoría de Hallazgos (Power BI) — Fase 7 (TFM ChileCompra Data Platform)

**Autor:** René Alberto Jara Balboa  
**Programa:** Máster en Ciencia de Datos e Inteligencia Artificial — UCM  
**Proyecto:** ChileCompra Data Platform  
**Fecha:** 12-02-2026  
**Fase:** Fase 7 — Auditoría (cierre documental de BI)  
**Objeto auditado:** Texto de **Hallazgos + Interpretación** en dashboards Power BI (v5)

---

## 1. Objetivo de esta auditoría

El objetivo de este documento es **auditar formalmente** que los textos de:

- **Hallazgos clave**
- **Interpretación**
- **Limitaciones metodológicas**

presentes en los dashboards Power BI del TFM cumplen con rigor académico exigible por tribunal UCM, es decir:

- son **descriptivos**
- no presentan **causalidad**
- no realizan **inferencias no sustentadas**
- no contienen **juicios normativos**
- están alineados con el contrato metodológico del proyecto

Este documento constituye evidencia escrita de control metodológico y se integra como parte de la auditoría final del TFM.

---

## 2. Alcance auditado

### 2.1 Dashboards incluidos en esta auditoría

La auditoría aplica a los dashboards que contienen textos explícitos de hallazgos e interpretación, en particular:

- LIC (Licitaciones)
- OC (Órdenes de Compra)
- CRUCE_LIC_OC (módulos de consistencia)
- NO_CRUCE (explicación de “no aplica”)
- DT_TEND / DT_SECT (tendencias y segmentaciones del cruce)
- HALLAZGOS (síntesis final del modelo BI)
- RECON (validación numérica BI vs SQL)

Estos dashboards corresponden al modelo Power BI versión v5.

---

### 2.2 Elementos auditados

Los elementos evaluados fueron:

- Textos de hallazgos clave (bullets o párrafos en visual tipo textbox)
- Textos de interpretación narrativa
- Textos de limitaciones metodológicas
- Coherencia del lenguaje con el contrato BI (DW como fuente oficial)
- Coherencia con reglas transversales del proyecto (moneda, periodo, trazabilidad)

---

### 2.3 Fuentes documentales utilizadas

La auditoría se construyó sobre los siguientes antecedentes:

- Documento PDF del modelo BI v5 (paneles y textos integrados en Power BI).
- Archivo TSV de medidas DAX (medidas reales implementadas).
- README de auditoría numérica (coherencia DW vs Power BI).
- README_BI.md (kit reproducible BI-0 / BI-1).
- Readme_BI_ver2.0.md (Base de Conocimiento Oficial DW → BI).
- Documentos oficiales de fases, scoping, arquitectura y estado Fase 5.

---

## 3. Marco metodológico (criterio tribunal)

### 3.1 Principio rector: BI como evidencia del DW

La capa BI del TFM se rige por el principio explícito:

> **Power BI NO es un motor de transformación analítica**,  
> sino una capa de visualización y evidencia del Data Warehouse semántico (DW_SEM).

En consecuencia:

- Las transformaciones de negocio deben existir en DW / DW_SEM.
- Power BI no debe introducir lógica analítica oculta en Power Query.
- Los notebooks generan evidencia reproducible y datasets auxiliares (cuando aplica).

---

### 3.2 Regla crítica: multimoneda sin conversión

El proyecto opera sobre un universo multimoneda (CLP, USD, EUR, CLF, UTM, etc.).

Regla obligatoria:

- **No se realizan conversiones monetarias.**
- **No se suman montos entre monedas distintas.**
- Toda lectura monetaria requiere selección explícita de moneda única.

Esto se declara como restricción metodológica transversal en toda la BI.

---

### 3.3 Regla crítica: prohibición de causalidad y juicio institucional

Los dashboards se definen como capa académica descriptiva.

Por tanto:

- No se realizan inferencias causales.
- No se atribuyen razones (“esto se debe a…”).
- No se evalúa desempeño institucional (“eficiencia”, “cumplimiento”, “irregularidad”).
- No se realizan conclusiones normativas o jurídicas.

El enfoque es estrictamente:

- descriptivo
- documental
- basado en evidencia reproducible

---

### 3.4 Regla conceptual: separación obligatoria LIC vs OC

LIC y OC representan entidades distintas:

- LIC representa planificación y proceso.
- OC representa ejecución administrativa.

Consecuencia metodológica:

- LIC y OC se analizan en dashboards separados.
- El cruce LIC–OC se trata solo como consistencia estructural parcial,
  nunca como vínculo contractual determinístico.

---

## 4. Hallazgos correctos (auditados como OK)

A continuación se listan patrones de hallazgos identificados como **correctos y defendibles**.

### 4.1 Hallazgos descriptivos (OK)

Ejemplos auditados como válidos:

- “Se observa distribución de OC por período bajo los filtros aplicados.”
- “Se identifica concentración de registros en determinadas categorías.”
- “Se observan variaciones mensuales en conteos y montos agregados.”
- “El comportamiento depende estrictamente del subconjunto filtrado.”

Estos hallazgos cumplen porque:

- describen valores observables
- no atribuyen causa
- no interpretan desempeño

---

### 4.2 Hallazgos técnicos sobre calidad de datos (OK)

Ejemplos defendibles:

- “Se detectan registros con moneda missing/unknown.”
- “Se observan valores atípicos documentados como flags.”
- “Existen periodos NO-OP y EXCEPCIÓN_FUENTE documentados.”

Estos hallazgos cumplen porque:

- son técnicos y trazables
- reflejan condiciones reales de fuente pública
- no generan interpretación normativa

---

### 4.3 Hallazgos sobre cruce LIC–OC (OK con restricción)

Los hallazgos de cruce son aceptables cuando se expresan como:

- “cruce administrativo parcial”
- “coincidencia por código”
- “consistencia estructural”

y se declaran explícitamente sus límites.

Este punto es clave porque el tribunal suele cuestionar
si LIC ↔ OC es determinístico.

---

## 5. Hallazgos débiles o riesgosos detectados

Se identificaron expresiones con riesgo académico (no por DAX, sino por redacción).

### 5.1 Uso de lenguaje inferencial

Riesgo detectado:

- “lo que sugiere…”
- “esto evidencia que…”
- “esto se debe a…”

Motivo de riesgo:

- introduce explicación causal implícita
- abre preguntas del tribunal (“¿cómo lo pruebas?”)

---

### 5.2 Uso de afirmaciones fuertes no verificadas

Riesgo detectado:

- “validar consistencia”
- “confirmar que…”
- “se concluye que…”

Motivo:

- sugiere validación externa o causalidad
- puede interpretarse como conclusión científica sin prueba

---

### 5.3 Riesgo semántico por “evaluación institucional”

Riesgo detectado si aparece en textos:

- “eficiencia”
- “cumplimiento”
- “irregularidad”
- “mala gestión”
- “desempeño”

Motivo:

- el TFM no tiene alcance jurídico ni evaluativo
- el tribunal puede considerarlo extrapolación no permitida

---

## 6. Auditoría de medidas DAX (resultado)

Se revisaron medidas reales implementadas en Power BI (archivo TSV).

### 6.1 Resultado general

- Se detectaron ~64 medidas.
- No se detectaron medidas con semántica causal o evaluativa.
- Predominan agregaciones descriptivas:

  - COUNT / DISTINCTCOUNT
  - SUM
  - ratios y porcentajes
  - medidas de cobertura y distribución

Conclusión:

> Las medidas DAX son consistentes con una BI descriptiva.
> El riesgo principal no está en el cálculo, sino en la narrativa escrita.

---

### 6.2 Riesgo comunicacional identificado

Se detectaron medidas con uso de `REMOVEFILTERS`.

Esto no constituye error técnico, pero requiere nota metodológica breve
para evitar sospecha tribunal (“se están forzando resultados”).

---

## 7. Recomendación de redacción mínima defendible (tribunal-proof)

Para blindar el texto de Hallazgos e Interpretación,
se adoptó la siguiente regla obligatoria de redacción:

### 7.1 Plantilla estándar para hallazgos

Todo hallazgo debe expresarse como:

1. **Visual:** “Según el gráfico/tabla/tarjeta…”
2. **Observación:** “se observa…”
3. **Condición:** “bajo el subconjunto filtrado…”
4. **Límite:** “no implica causalidad ni evaluación institucional.”

---

### 7.2 Frases permitidas (seguras)

- “Se observa…”
- “Se identifica…”
- “En términos agregados…”
- “Bajo filtros aplicados…”
- “Este resultado es descriptivo…”
- “Depende de la calidad del dato…”
- “No se infiere causalidad…”

---

### 7.3 Frases prohibidas (eliminar)

- “Esto se debe a…”
- “Esto demuestra…”
- “Esto confirma…”
- “Esto evidencia…”
- “Se concluye que…”
- “Se detecta irregularidad…”

---

## 8. Texto final aprobado (Hallazgos + Interpretación)

A partir de la auditoría se generó un texto final corregido para el dashboard CRUCE/HALLAZGOS.

### 8.1 HALLAZGOS CLAVE (versión aprobada)

- **Relación LIC–OC (cobertura administrativa):** Bajo los filtros aplicados, se observa que una proporción relevante de Órdenes de Compra (OC) contiene un código de licitación informado en el campo `codigolicitacion`, permitiendo un cruce administrativo parcial con licitaciones.

- **OC sin vínculo explícito a LIC:** En el subconjunto filtrado, se observa que una fracción significativa de OC no presenta valor informado en `codigolicitacion`, por lo que no puede ser vinculada directamente a una licitación mediante este mecanismo.

- **Distribución temporal del cruce:** La cobertura del cruce LIC–OC presenta variación por período. Se observan diferencias entre meses, lo cual refleja cambios en la composición del subconjunto disponible y en la presencia del campo `codigolicitacion`.

- **Distribución por estado (OC vinculadas vs no vinculadas):** Al segmentar por estado, se observan diferencias en la proporción de OC con y sin código de licitación informado, lo cual permite caracterizar descriptivamente el comportamiento del registro administrativo bajo los filtros seleccionados.

- **Diferencia entre volumen LIC y OC:** En términos agregados, el volumen total de OC puede superar el volumen de LIC, lo cual es consistente con un modelo administrativo donde múltiples OC pueden estar asociadas a una misma licitación o bien existir OC que no registran código de licitación.

**Nota metodológica:** Estos hallazgos son estrictamente descriptivos, dependen del subconjunto filtrado y de la calidad del dato público disponible. No se infiere causalidad ni se realizan evaluaciones institucionales.

---

### 8.2 INTERPRETACIÓN (versión aprobada)

Los resultados presentados permiten describir el grado de cobertura del vínculo administrativo LIC–OC utilizando el campo `codigolicitacion` como llave de cruce. Este vínculo debe interpretarse como una aproximación técnica basada en disponibilidad de datos, no como trazabilidad contractual completa.

En el subconjunto filtrado, la existencia de OC sin código de licitación informado indica que una parte del universo no puede ser relacionada directamente con una licitación mediante este método. Esto puede estar asociado a múltiples factores de registro o estructura del dato (por ejemplo, ausencia de campo informado, mecanismos de compra no asociados a licitación, o diferencias en el proceso administrativo), sin que sea posible determinar una causa específica únicamente desde este modelo descriptivo.

Por tanto, el dashboard constituye evidencia de comportamiento agregado del registro disponible y sirve como apoyo documental para validar coherencia general del modelo analítico, sin atribuir explicaciones causales ni emitir conclusiones sobre eficiencia, cumplimiento o desempeño institucional.

**Limitación explícita:** El cruce LIC–OC es exploratorio y depende de la consistencia del identificador disponible. Los resultados no representan una verificación contractual ni un mecanismo normativo de auditoría legal.

---

## 9. Evidencias y trazabilidad asociada

### 9.1 Evidencia técnica (medidas y modelo)

- Medidas DAX exportadas (TSV) como prueba de ausencia de inferencias.
- Modelo Power BI v5 con textos de metodología y limitaciones integradas.
- Dashboard RECON como validación numérica BI vs SQL.

---

### 9.2 Evidencia documental de continuidad (contrato BI)

Documentos utilizados para sustentar el rigor metodológico:

- README_BI.md (kit reproducible BI-0 / BI-1)
- Readme_BI_ver2.0.md (base de conocimiento oficial DW → BI)
- Estado actual Fase 5 (fuente de verdad)
- Checklist de verificación BI pre-TFM

Estos documentos fijan reglas oficiales:

- BI es evidencia del DW.
- Moneda sin conversión.
- No causalidad.
- Separación LIC vs OC.
- Cruce solo como consistencia.

---

## 10. Dictamen final de auditoría (tribunal)

### Resultado

✅ **APROBADO**

Los hallazgos y textos interpretativos auditados cumplen con rigor académico exigible por tribunal UCM, debido a que:

- se formulan como descripciones observables,
- no contienen inferencias causales,
- no realizan evaluaciones normativas,
- se apoyan en reglas explícitas de moneda y alcance temporal,
- se encuentran alineados con el contrato documental DW → BI.

### Riesgo residual identificado

El único riesgo detectado corresponde a redacción previa con términos fuertes (“sugiere”, “evidencia”, “validar”), los cuales fueron reemplazados por formulaciones descriptivas controladas.

El riesgo de tribunal se considera **BAJO**.

---

## 11. Declaración de cierre

Esta auditoría certifica que la capa BI del TFM presenta hallazgos de forma académicamente válida y defendible, preservando:

- trazabilidad DW → BI,
- coherencia metodológica,
- y límites explícitos del dominio ChileCompra.

El bloque **Hallazgos + Interpretación** queda cerrado y aprobado como evidencia final para inclusión en memoria y defensa.

---

**Estado:** CERRADO  
**Auditoría:** OK  
**Fecha cierre:** 12-02-2026  
