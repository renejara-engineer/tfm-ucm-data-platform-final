# ============================================================
# ANALISIS EXPLORATORIO DE CRUCE LIC ↔ OC (ChileCompra)
# Ejecutable como .py (sin Jupyter)
# SOLO observación: no modifica datos, no imputa, no normaliza
# ============================================================

import os
import csv
import pandas as pd

pd.set_option('display.max_columns', None)
pd.set_option('display.width', 200)

# ------------------------------------------------------------
# 0 - PARAMETROS (AJUSTA SOLO ESTO SI CAMBIAN TUS RUTAS)
# ------------------------------------------------------------
RUTA_LIC = '/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/01_LIC'
RUTA_OC  = '/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/02_OC'

NROWS_SAMPLE = 100_000
ENCODINGS_TRY = ('utf-8', 'latin1')  # probamos utf-8 y luego latin1 (ChileCompra típicamente latin1)

PATRONES = ['extern', 'licit', 'codigo', 'id']

# ------------------------------------------------------------
# 0.1 - DISPLAY SEGURO (Jupyter o consola)
# ------------------------------------------------------------
try:
    from IPython.display import display as _display
    def display(x):
        _display(x)
except Exception:
    def display(x):
        print(x)

# ------------------------------------------------------------
# 1 - UTILIDADES: DETECTAR SEPARADOR Y LEER HEADER (SIN PANDAS)
# ------------------------------------------------------------
def detectar_sep_y_header(path, encodings=ENCODINGS_TRY):
    """
    Lee SOLO la primera línea y detecta separador probable (, o ;)
    Retorna (encoding_usado, sep, columnas:list)
    """
    last_err = None
    for enc in encodings:
        try:
            with open(path, 'r', encoding=enc, errors='strict', newline='') as f:
                first_line = f.readline().strip('\n\r')
            # Heurística simple: cuál separador aparece más
            comma = first_line.count(',')
            semi  = first_line.count(';')
            sep = ';' if semi > comma else ','
            # Parseo de header con csv
            cols = next(csv.reader([first_line], delimiter=sep))
            # strip de espacios
            cols = [c.strip() for c in cols]
            return enc, sep, cols
        except Exception as e:
            last_err = e
            continue
    raise RuntimeError(f"No se pudo leer header: {path}. Ultimo error: {last_err}")

def listar_csvs(ruta):
    return [a for a in sorted(os.listdir(ruta)) if a.lower().endswith('.csv')]

# ------------------------------------------------------------
# 1 - INSPECCION DE ESTRUCTURA (HEADERS)
# ------------------------------------------------------------
def leer_headers_csv(ruta):
    info = []
    for archivo in listar_csvs(ruta):
        path = os.path.join(ruta, archivo)
        try:
            enc, sep, cols = detectar_sep_y_header(path)
            info.append({
                'archivo': archivo,
                'n_columnas': len(cols),
                'encoding': enc,
                'sep': sep,
                'columnas': cols
            })
        except Exception as e:
            info.append({
                'archivo': archivo,
                'n_columnas': None,
                'encoding': None,
                'sep': None,
                'columnas': None,
                'error': str(e)
            })
    return info

headers_lic = leer_headers_csv(RUTA_LIC)
headers_oc  = leer_headers_csv(RUTA_OC)

# Map rápido archivo -> (encoding, sep)
meta_lic = {h['archivo']: {'encoding': h['encoding'], 'sep': h['sep']} for h in headers_lic if h.get('encoding')}
meta_oc  = {h['archivo']: {'encoding': h['encoding'], 'sep': h['sep']} for h in headers_oc  if h.get('encoding')}

def headers_to_df(headers):
    registros = []
    for h in headers:
        if not h.get('columnas'):
            continue
        for i, col in enumerate(h['columnas']):
            registros.append({'archivo': h['archivo'], 'orden': i, 'columna': col})
    return pd.DataFrame(registros)

headers_lic_df = headers_to_df(headers_lic)
headers_oc_df  = headers_to_df(headers_oc)

print("\nHEADERS LIC (primeras filas)")
display(headers_lic_df.head(20))

print("\nHEADERS OC (primeras filas)")
display(headers_oc_df.head(20))

# ------------------------------------------------------------
# 1.1 - PRESENCIA / AUSENCIA DE COLUMNAS POR MES
# ------------------------------------------------------------
def matriz_presencia(headers_df):
    return (
        headers_df.assign(presente=1)
        .pivot_table(index='columna', columns='archivo', values='presente', fill_value=0)
        .sort_index()
    )

presencia_lic = matriz_presencia(headers_lic_df)
presencia_oc  = matriz_presencia(headers_oc_df)

print("\nPRESENCIA COLUMNAS LIC (matriz)")
display(presencia_lic)

print("\nPRESENCIA COLUMNAS OC (matriz)")
display(presencia_oc)

# ------------------------------------------------------------
# 2 - DETECCION DE CAMPOS CANDIDATOS DE CRUCE
# ------------------------------------------------------------
def detectar_candidatos(headers_df):
    df = headers_df.copy()
    df['col_lower'] = df['columna'].astype(str).str.lower()
    mask = df['col_lower'].apply(lambda x: any(p in x for p in PATRONES))
    return df[mask].sort_values(['archivo', 'orden'])

candidatos_lic = detectar_candidatos(headers_lic_df)
candidatos_oc  = detectar_candidatos(headers_oc_df)

print("\nCANDIDATOS LIC")
display(candidatos_lic)

print("\nCANDIDATOS OC")
display(candidatos_oc)

# ------------------------------------------------------------
# 3 - ANALISIS DE CONTENIDO (MUESTRAS CONTROLADAS)
# ------------------------------------------------------------
def leer_muestra_csv(ruta, archivo, usecols, nrows):
    path = os.path.join(ruta, archivo)
    # metadata detectada desde header
    meta = meta_lic.get(archivo) if ruta == RUTA_LIC else meta_oc.get(archivo)
    if not meta:
        # fallback si no quedó en meta por algún error
        enc, sep, _ = detectar_sep_y_header(path)
    else:
        enc, sep = meta['encoding'], meta['sep']

    return pd.read_csv(
        path,
        usecols=usecols,
        nrows=nrows,
        encoding=enc,
        sep=sep,
        engine='python'  # más tolerante con CSVs “raros”
    )

def analizar_campo(ruta, archivo, campo):
    df = leer_muestra_csv(ruta, archivo, [campo], NROWS_SAMPLE)
    total = len(df)
    col = df[campo]

    nulos = col.isna().sum()
    vacios = (col.astype(str).str.strip() == '').sum()
    cardinalidad = col.nunique(dropna=True)
    ejemplos = col.dropna().astype(str).unique()[:5]

    return {
        'archivo': archivo,
        'campo': campo,
        'filas_muestra': total,
        '%_nulos': round(nulos / total * 100, 2) if total else None,
        '%_vacios': round(vacios / total * 100, 2) if total else None,
        'cardinalidad_aprox': int(cardinalidad) if total else None,
        'ejemplos': ejemplos
    }

analisis_campos = []

# FOCO: 2025-01 (si existen esos archivos)
lic_2025_01 = 'LIC_2025-02.csv'
oc_2025_01  = 'OC_2025-02.csv'

if lic_2025_01 in listar_csvs(RUTA_LIC):
    for _, row in candidatos_lic[candidatos_lic['archivo'].eq(lic_2025_01)].iterrows():
        analisis_campos.append(analizar_campo(RUTA_LIC, row['archivo'], row['columna']))
else:
    print(f"\nAVISO: no existe {lic_2025_01} en {RUTA_LIC}")

if oc_2025_01 in listar_csvs(RUTA_OC):
    for _, row in candidatos_oc[candidatos_oc['archivo'].eq(oc_2025_01)].iterrows():
        analisis_campos.append(analizar_campo(RUTA_OC, row['archivo'], row['columna']))
else:
    print(f"\nAVISO: no existe {oc_2025_01} en {RUTA_OC}")

analisis_campos_df = pd.DataFrame(analisis_campos)
print("\nANALISIS DE CONTENIDO (muestra controlada, foco 2025-01)")
display(analisis_campos_df)

# ------------------------------------------------------------
# 4 - PRUEBAS DE CRUCE REAL (JOIN)
# ------------------------------------------------------------
def prueba_cruce(lic_file, oc_file, campo_lic, campo_oc):
    lic = leer_muestra_csv(RUTA_LIC, lic_file, [campo_lic], NROWS_SAMPLE).dropna()
    oc  = leer_muestra_csv(RUTA_OC,  oc_file,  [campo_oc],  NROWS_SAMPLE).dropna()

    lic['key'] = lic[campo_lic].astype(str)
    oc['key']  = oc[campo_oc].astype(str)

    merge = lic[['key']].merge(oc[['key']], on='key', how='inner')

    return {
        'lic_file': lic_file,
        'oc_file': oc_file,
        'campo_lic': campo_lic,
        'campo_oc': campo_oc,
        'lic_filas_muestra_no_null': len(lic),
        'oc_filas_muestra_no_null': len(oc),
        'matches': len(merge),
        '%_match_sobre_lic': round(len(merge) / len(lic) * 100, 2) if len(lic) else 0.0
    }

cruces = []
if (lic_2025_01 in listar_csvs(RUTA_LIC)) and (oc_2025_01 in listar_csvs(RUTA_OC)):
    lic_cols = candidatos_lic[candidatos_lic['archivo'].eq(lic_2025_01)]['columna'].unique()
    oc_cols  = candidatos_oc[candidatos_oc['archivo'].eq(oc_2025_01)]['columna'].unique()

    # probamos cruces entre candidatos que contengan 'codigo' (incluye CodigoExterno si existe)
    lic_cols_codigo = [c for c in lic_cols if 'codigo' in str(c).lower()]
    oc_cols_codigo  = [c for c in oc_cols  if 'codigo' in str(c).lower()]

    for lc in lic_cols_codigo:
        for oc in oc_cols_codigo:
            try:
                cruces.append(prueba_cruce(lic_2025_01, oc_2025_01, lc, oc))
            except Exception as e:
                cruces.append({
                    'lic_file': lic_2025_01,
                    'oc_file': oc_2025_01,
                    'campo_lic': lc,
                    'campo_oc': oc,
                    'error': str(e)
                })
else:
    print("\nAVISO: no se ejecutan cruces porque falta LIC_2025-01 o OC_2025-01")

cruces_df = pd.DataFrame(cruces)
print("\nRESULTADOS DE CRUCE (muestra controlada, foco 2025-01)")
display(cruces_df)

# ------------------------------------------------------------
# 5 - CONCLUSION TECNICA (FACTUAL)
# ------------------------------------------------------------
print("""
CONCLUSION TECNICA (SIN OPINION)
--------------------------------
Este script produce evidencia factual mediante:
- Comparación de headers por mes (LIC y OC)
- Detección de candidatos por patrones (extern/licit/codigo/id)
- Métricas de contenido en muestra (nulos, vacíos, cardinalidad, ejemplos)
- % match real en joins por campos candidatos (foco 2025-01)

La conclusión final debe basarse en las tablas generadas:
- presencia_lic / presencia_oc
- candidatos_lic / candidatos_oc
- analisis_campos_df
- cruces_df
""")
