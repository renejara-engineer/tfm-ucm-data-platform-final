# Hallazgos Críticos — Modelado vs Negocio  

## 1. Contexto del hallazgo

Durante el desarrollo del TFM *ChileCompra Data Platform*, y particularmente al iniciar la Fase 5 (capa analítica y de consumo), se identificó un **conflicto estructural entre el modelo de datos inicial y la realidad del negocio de ChileCompra**.

Este hallazgo no surge como un error puntual, sino como el resultado natural de avanzar desde:

- un modelo técnicamente correcto (Fases 2–4),
- hacia un uso analítico real con fines de Business Intelligence.

La detección del conflicto confirma el carácter **iterativo y evolutivo** del proyecto, alineado con buenas prácticas de ingeniería de datos y analítica avanzada.

---

## 2. Advertencias tempranas realizadas en fases previas

Desde fases anteriores del proyecto, se había señalado explícitamente que:

- Una **licitación (LIC)** puede:
  - adjudicar múltiples productos,
  - adjudicar a **más de un proveedor**,
  - adjudicarse de forma parcial o progresiva en el tiempo.
- Las **órdenes de compra (OC)**:
  - no siempre se generan en el mismo periodo que la licitación,
  - pueden materializarse en múltiples OC asociadas a una misma LIC.
- Forzar una relación 1:1 entre LIC y OC implica:
  - pérdida de información,
  - distorsión de métricas,
  - riesgo de análisis engañoso en BI.

Estas advertencias fueron consideradas conceptualmente, pero **no se manifestaron como bloqueo real** hasta intentar explotar el DW con KPIs concretos en Fase 5.

---

## 3. Conflicto detectado en Fase 5

Al intentar definir KPIs analíticos (ej. montos adjudicados, concentración por proveedor, eficiencia de compra), se evidenció que:

- El modelo inicial **no soportaba correctamente**:
  - licitaciones con múltiples proveedores para un mismo producto,
  - análisis proveedor–producto dentro de una licitación,
  - trazabilidad clara LIC → OC sin simplificaciones indebidas.
- Cualquier intento de:
  - aplanar la licitación a un solo proveedor,
  - forzar cuadraturas exactas LIC = OC en un único periodo,
  - o calcular KPIs directamente desde MART,
  
  llevaba inevitablemente a **resultados analíticos incorrectos o engañosos**.

Este punto marca un **quiebre entre “modelo correcto” y “modelo útil para BI”**.

---

## 4. Riesgo analítico si no se corregía el modelado

De no haberse detenido el avance en Fase 5, el proyecto habría incurrido en:

- KPIs inflados o subestimados.
- Doble conteo de montos al cruzar dimensiones.
- Dashboards estéticamente correctos pero **conceptualmente falsos**.
- Falta de trazabilidad real entre hechos y métricas.

Desde un punto de vista académico, esto habría implicado:

- una **falta de rigor metodológico**,
- un uso inadecuado de herramientas BI,
- y una representación incorrecta del dominio ChileCompra.

---

## 5. Decisión de corrección y carácter iterativo del proceso

Frente a este hallazgo, se decidió conscientemente:

- **No avanzar a BI** sin corregir el modelo analítico.
- Tratar el conflicto como un **hallazgo crítico**, no como un error.
- Replantear el grano de los hechos **sin rediseñar las fases cerradas**.
- Documentar explícitamente:
  - las advertencias previas,
  - el conflicto detectado,
  - y la justificación de la solución adoptada.

Este enfoque refuerza el carácter del TFM como:
> un proyecto de ingeniería de datos real,  
> iterativo, reflexivo y alineado con la práctica profesional.

---

## 6. Relación con las fases del TFM

- **Fases 1–4:**  
  Permanecen válidas, cerradas y correctas en su contexto.
- **Fase 5:**  
  Actúa como fase de validación analítica profunda, revelando
  limitaciones del modelo inicial al enfrentarse a BI real.
- **Corrección aplicada:**  
  Se enmarca como **ajuste analítico**, no como fallo de diseño previo.

---

## 7. Conclusión del hallazgo

El conflicto entre modelado y negocio detectado en Fase 5:

- No invalida el trabajo previo.
- Demuestra madurez técnica y metodológica.
- Justifica plenamente la adopción de un enfoque analítico más robusto.
- Refuerza la calidad académica del TFM.

Este hallazgo constituye uno de los **puntos de mayor valor del proyecto**, al evidenciar la diferencia entre:

- “un DW que carga datos”
- y “un DW que habilita decisiones correctas”.

---

**Fin del documento.**
