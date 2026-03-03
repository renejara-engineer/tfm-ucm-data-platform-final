import os
import pandas as pd

RUTA_LIC = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/01_LIC"
RUTA_OC  = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/02_OC"
NROWS_SAMPLE = 100_000

def detectar_sep(path):
    with open(path, encoding="latin1", errors="ignore") as f:
        header = f.readline()
    return ";" if header.count(";") > header.count(",") else ","

def leer_header_cols(path):
    sep = detectar_sep(path)
    with open(path, encoding="latin1", errors="ignore") as f:
        header = f.readline().strip("\n\r")
    cols = [c.strip() for c in header.split(sep)]
    return sep, cols

def read_sample(path, cols, nrows):
    sep = detectar_sep(path)
    return pd.read_csv(
        path,
        usecols=cols,
        nrows=nrows,
        encoding="latin1",
        sep=sep,
        engine="python"
    )

def elegir_columna_oc(cols_oc):
    """
    Devuelve la mejor columna candidata para relacionar con LIC.
    Prioridad:
      1) contiene 'codigolicit' (variantes)
      2) contiene 'codigoextern' (por si viene así en OC)
      3) columna exactamente 'Codigo'
    """
    lower_map = {c.lower(): c for c in cols_oc}

    # 1) Buscar variantes de CodigoLicitacion
    for key in lower_map.keys():
        if "codigolicit" in key:   # captura codigolicitacion, codigo_licitacion, etc.
            return lower_map[key]

    # 2) Buscar CodigoExterno si existiera en OC
    for key in lower_map.keys():
        if "codigoextern" in key:
            return lower_map[key]

    # 3) Fallback a Codigo
    if "codigo" in lower_map:
        return lower_map["codigo"]

    return None

def cruce_mes(mes):
    lic_file = f"LIC_{mes}.csv"
    oc_file  = f"OC_{mes}.csv"

    lic_path = os.path.join(RUTA_LIC, lic_file)
    oc_path  = os.path.join(RUTA_OC,  oc_file)

    if not (os.path.exists(lic_path) and os.path.exists(oc_path)):
        return {"mes": mes, "status": "missing_file"}

    # LIC: necesitamos CodigoExterno (si no está, se reporta)
    _, lic_cols = leer_header_cols(lic_path)
    if "CodigoExterno" not in lic_cols:
        return {"mes": mes, "status": "LIC_sin_CodigoExterno"}

    # OC: detectar columna candidata real
    _, oc_cols = leer_header_cols(oc_path)
    col_oc = elegir_columna_oc(oc_cols)
    if col_oc is None:
        return {"mes": mes, "status": "OC_sin_columna_candidata"}

    # Leer muestras mínimas
    lic = read_sample(lic_path, ["CodigoExterno"], NROWS_SAMPLE)
    oc  = read_sample(oc_path,  [col_oc],         NROWS_SAMPLE)

    lic_keys = set(lic["CodigoExterno"].dropna().astype(str))
    oc_keys  = set(oc[col_oc].dropna().astype(str))

    inter = lic_keys & oc_keys

    return {
        "mes": mes,
        "status": "OK",
        "oc_col_usada": col_oc,
        "lic_keys": len(lic_keys),
        "oc_keys": len(oc_keys),
        "matches": len(inter),
        "%match_lic": round(len(inter)/len(lic_keys)*100, 4) if lic_keys else 0.0,
        "ej_match": list(inter)[:10],
        "ej_lic_no": list(lic_keys - oc_keys)[:10],
        "ej_oc_no":  list(oc_keys - lic_keys)[:10],
    }

for mes in ["2025-02", "2025-03", "2025-04", "2025-05", "2025-06"]:
    r = cruce_mes(mes)
    print("\n", r)
