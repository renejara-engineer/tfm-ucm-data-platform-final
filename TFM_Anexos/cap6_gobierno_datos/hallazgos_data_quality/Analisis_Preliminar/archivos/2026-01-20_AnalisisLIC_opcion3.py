import os

RUTA_LIC = "/home/engineer/Documents/Proyectos/TFM_CSV_Biblioteca_Readme/01_LIC"

def detectar_sep_y_cols(path):
    with open(path, encoding="latin1", errors="ignore") as f:
        header = f.readline().strip("\n\r")
    sep = ";" if header.count(";") > header.count(",") else ","
    cols = [c.strip() for c in header.split(sep)]
    return cols

# --------------------------------------------------
# 1) LISTAR COLUMNAS POR MES (solo 2025)
# --------------------------------------------------
cols_por_mes = {}

for archivo in sorted(os.listdir(RUTA_LIC)):
    if archivo.startswith("LIC_2025") and archivo.endswith(".csv"):
        path = os.path.join(RUTA_LIC, archivo)
        cols_por_mes[archivo] = detectar_sep_y_cols(path)

print("\n=== COLUMNAS POR MES (LIC 2025) ===")
for mes, cols in cols_por_mes.items():
    print(f"\n{mes} ({len(cols)} columnas)")
    for c in cols:
        print(f"  - {c}")

# --------------------------------------------------
# 2) COLUMNAS COMUNES A TODOS LOS MESES 2025
# --------------------------------------------------
sets_cols = [set(v) for v in cols_por_mes.values()]
cols_comunes_2025 = sorted(set.intersection(*sets_cols))

print("\n=== COLUMNAS COMUNES A TODOS LOS MESES 2025 ===")
for c in cols_comunes_2025:
    print(f"  - {c}")

# --------------------------------------------------
# 3) COLUMNAS EXCLUSIVAS DE 2025 (vs 2024)
# --------------------------------------------------
cols_2024 = set()

for archivo in sorted(os.listdir(RUTA_LIC)):
    if archivo.startswith("LIC_2024") and archivo.endswith(".csv"):
        path = os.path.join(RUTA_LIC, archivo)
        cols_2024.update(detectar_sep_y_cols(path))

cols_2025 = set().union(*sets_cols)

exclusivas_2025 = sorted(cols_2025 - cols_2024)

print("\n=== COLUMNAS NUEVAS EN 2025 (NO EXISTEN EN 2024) ===")
for c in exclusivas_2025:
    print(f"  - {c}")

# --------------------------------------------------
# 4) COLUMNAS QUE EXISTIAN EN 2024 Y DESAPARECEN EN 2025
# --------------------------------------------------
desaparecen_2025 = sorted(cols_2024 - cols_2025)

print("\n=== COLUMNAS DE 2024 QUE DESAPARECEN EN 2025 ===")
for c in desaparecen_2025:
    print(f"  - {c}")
