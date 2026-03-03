import os
import pandas as pd

RUTA_OC = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/02_OC"
ENC = "latin1"

def detectar_sep(path):
    with open(path, encoding=ENC, errors="ignore") as f:
        h = f.readline()
    return ";" if h.count(";") > h.count(",") else ","

def normalize(col):
    return col.strip().strip('"').strip("'").lower()

def columnas_candidatas_oc(archivo):
    path = os.path.join(RUTA_OC, archivo)
    sep = detectar_sep(path)
    with open(path, encoding=ENC, errors="ignore") as f:
        header = f.readline().strip("\n\r")
    cols = [c.strip() for c in header.split(sep)]

    res = []
    for c in cols:
        cn = normalize(c)
        if any(k in cn for k in ["licit", "codigo", "extern"]):
            res.append({
                "archivo": archivo,
                "columna": c,
                "col_normalizada": cn
            })
    return res

files = sorted([f for f in os.listdir(RUTA_OC) if f.endswith(".csv")])

out = []
for f in files:
    out.extend(columnas_candidatas_oc(f))

df = pd.DataFrame(out)
print(df.to_string(index=False))
