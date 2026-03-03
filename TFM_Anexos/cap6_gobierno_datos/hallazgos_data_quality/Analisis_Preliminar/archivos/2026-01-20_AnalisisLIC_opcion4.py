import os
import pandas as pd

RUTA_LIC = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/01_LIC"
NROWS = 100_000
ENC = "latin1"

def detectar_sep(path):
    with open(path, encoding=ENC, errors="ignore") as f:
        header = f.readline()
    return ";" if header.count(";") > header.count(",") else ","

def header_cols(path):
    sep = detectar_sep(path)
    with open(path, encoding=ENC, errors="ignore") as f:
        h = f.readline().strip("\n\r")
    cols = [c.strip() for c in h.split(sep)]
    return sep, cols

def normalize(col):
    return col.strip().strip('"').strip("'").strip().lower()

def find_col_real(cols, target_norm):
    for c in cols:
        if normalize(c) == target_norm:
            return c.strip().strip('"').strip("'")
    return None

def perfil_campo(file, target_norm="codigoexterno"):
    path = os.path.join(RUTA_LIC, file)
    sep, cols = header_cols(path)

    col_real = find_col_real(cols, target_norm)
    if col_real is None:
        return {"archivo": file, "status": "NO_EXISTE_COL"}

    df = pd.read_csv(
        path,
        usecols=[col_real],   # ← SIN comillas
        nrows=NROWS,
        encoding=ENC,
        sep=sep,
        engine="python"
    )

    s = df[col_real]
    total = len(s)
    nulos = int(s.isna().sum())
    vacios = int((s.astype(str).str.strip() == "").sum())
    uniq = int(s.dropna().astype(str).nunique())
    ejemplos = list(s.dropna().astype(str).unique()[:5])

    return {
        "archivo": file,
        "status": "OK",
        "col_usada": col_real,
        "filas_muestra": total,
        "%nulos": round(nulos/total*100, 2),
        "%vacios": round(vacios/total*100, 2),
        "cardinalidad": uniq,
        "ejemplos": ejemplos
    }

files = [
    "LIC_2024-12.csv",
    "LIC_2025-02.csv",
    "LIC_2025-03.csv",
    "LIC_2025-04.csv",
    "LIC_2025-05.csv",
    "LIC_2025-06.csv",
    "LIC_2025-07.csv",
    "LIC_2025-08.csv",
    "LIC_2025-09.csv",
    "LIC_2025-10.csv"


]

res = []
for f in files:
    if os.path.exists(os.path.join(RUTA_LIC, f)):
        res.append(perfil_campo(f, "codigoexterno"))
    else:
        res.append({"archivo": f, "status": "NO_EXISTE_ARCHIVO"})

df = pd.DataFrame(res)
print(df.to_string(index=False))

