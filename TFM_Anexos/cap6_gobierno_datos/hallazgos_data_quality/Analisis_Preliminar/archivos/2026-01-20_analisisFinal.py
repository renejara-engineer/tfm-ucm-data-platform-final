import os
import pandas as pd

RUTA_LIC = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/01_LIC"
RUTA_OC  = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/02_OC"
NROWS = 100_000
ENC = "latin1"

def detectar_sep(path):
    with open(path, encoding=ENC, errors="ignore") as f:
        h = f.readline()
    return ";" if h.count(";") > h.count(",") else ","

def header_cols(path):
    sep = detectar_sep(path)
    with open(path, encoding=ENC, errors="ignore") as f:
        header = f.readline().strip("\n\r")
    cols = [c.strip() for c in header.split(sep)]
    return sep, cols

def normalize(col):
    return col.strip().strip('"').strip("'").strip().lower()

def find_col_real(path, target_norm):
    """
    Devuelve el nombre REAL a usar en pandas (exactamente como viene en el CSV),
    pero si viene con comillas en el header, se las quitamos para usecols.
    """
    _, cols = header_cols(path)
    for c in cols:
        if normalize(c) == target_norm:
            # nombre que usará pandas: sin comillas externas
            return c.strip().strip('"').strip("'")
    return None

def read_col(path, target_norm):
    sep = detectar_sep(path)
    col_real = find_col_real(path, target_norm)
    if col_real is None:
        raise ValueError(f"No existe columna '{target_norm}' (normalizada) en {os.path.basename(path)}")

    s = pd.read_csv(
        path,
        usecols=[col_real],
        nrows=NROWS,
        encoding=ENC,
        sep=sep,
        engine="python"
    )[col_real].dropna().astype(str)

    return s, col_real

def cruce_mes(mes):
    lic_file = f"LIC_{mes}.csv"
    oc_file  = f"OC_{mes}.csv"

    p_lic = os.path.join(RUTA_LIC, lic_file)
    p_oc  = os.path.join(RUTA_OC,  oc_file)

    if not (os.path.exists(p_lic) and os.path.exists(p_oc)):
        return {"mes": mes, "status": "ARCHIVO_NO_EXISTE"}

    # LIC: CodigoExterno
    try:
        lic_s, lic_col = read_col(p_lic, "codigoexterno")
    except Exception as e:
        return {"mes": mes, "status": "LIC_SIN_COL", "error": str(e)}

    # OC: CodigoLicitacion
    try:
        oc_s, oc_col = read_col(p_oc, "codigolicitacion")
    except Exception as e:
        return {"mes": mes, "status": "OC_SIN_COL", "error": str(e)}

    set_lic = set(lic_s)
    set_oc  = set(oc_s)
    inter = set_lic & set_oc

    return {
        "mes": mes,
        "status": "OK",
        "lic_col_usada": lic_col,
        "oc_col_usada": oc_col,
        "lic_keys": len(set_lic),
        "oc_keys": len(set_oc),
        "matches": len(inter),
        "%match_lic": round(len(inter)/len(set_lic)*100, 2) if set_lic else 0,
        "%match_oc": round(len(inter)/len(set_oc)*100, 2) if set_oc else 0,
        "ejemplos_match": list(inter)[:5]
    }

meses = [
    "2024-12",
    "2025-02",
    "2025-03",
    "2025-04",
    "2025-05",
    "2025-06",
    "2025-07",
    "2025-08",
    "2025-09",
    "2025-10",
]

res = [cruce_mes(m) for m in meses]
df = pd.DataFrame(res)
print(df.to_string(index=False))
