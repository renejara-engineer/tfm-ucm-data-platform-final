from typing import List, Dict

def transform(raw: List[Dict]) -> List[Dict]:
    """Asegura campos y tipos. Devuelve filas listas para UPSERT."""
    rows = []
    for r in raw:
        rows.append({
            "id": str(r.get("id") or r.get("CodigoExterno") or "").strip(),
            "titulo": (r.get("titulo") or r.get("Nombre") or "").strip(),
            "estado": (r.get("estado") or r.get("Estado") or "").strip().lower(),
            "fecha_publicacion": r.get("fecha_publicacion") or r.get("FechaPublicacion"),
            "monto_estimado": r.get("monto_estimado") or r.get("MontoEstimado"),
            "raw": r.get("raw", r),
        })
    # filtra filas sin ID
    rows = [x for x in rows if x["id"]]
    return rows


