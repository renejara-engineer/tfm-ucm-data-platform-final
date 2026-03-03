import os
import httpx
from typing import List, Dict

BASE_URL = "https://api.mercadopublico.cl"  # ruta base real

def fetch_pages(api_key: str) -> List[Dict]:
    """Descarga páginas básicas de licitaciones. 
    Mantiene contrato: devolver lista[dict]."""
    if not api_key:
        # Seguridad adicional: si llega vacío, devolvemos lista vacía.
        return []

    # EJEMPLO simple (ajustar al endpoint real cuando tengas clave):
    # Aquí la idea es retornar una lista de dicts homogenizados.
    url = f"{BASE_URL}/licitaciones/v1/licitaciones"  # placeholder
    params = {"ticket": api_key, "estado": "publicada"}

    out = []
    with httpx.Client(timeout=30.0) as client:
        # Este llamado es ilustrativo; ajusta al endpoint y formato real.
        r = client.get(url, params=params)
        r.raise_for_status()
        data = r.json()

        # Normaliza a una lista de dicts simples (dependerá del esquema real)
        items = data.get("Listado", []) if isinstance(data, dict) else []
        for it in items:
            out.append({
                "id": str(it.get("CodigoExterno")),
                "titulo": it.get("Nombre", ""),
                "estado": it.get("Estado", ""),
                "fecha_publicacion": it.get("FechaPublicacion", None),
                "monto_estimado": it.get("MontoEstimado", None),
                "raw": it,
            })
    return out

