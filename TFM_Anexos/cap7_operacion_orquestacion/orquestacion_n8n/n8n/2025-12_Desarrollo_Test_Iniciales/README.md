# Evidencia — Fase 4 (n8n)

Contenido:
- docker-compose.n8n.resolved.yml: compose resuelto (config final efectiva)
- ps.txt: estado de contenedores
- ports_5678.txt: binding del puerto 5678
- health.txt: /healthz y /healthz/readiness
- n8n_public_tables.txt: tablas creadas por migraciones
- migrations_count.txt: cantidad de migraciones registradas
- tables_count_after_restart.txt: persistencia tras restart
- runtime_env_security.txt: variables runtime de DB/Auth/Encryption
- n8n_config_file.txt: archivo /home/node/.n8n/config con encryptionKey
- rest_login_unauth.txt: prueba de endpoint REST sin auth (401)

- rest_login_with_basic.txt: REST con Basic Auth HTTP (esperado: igual 401, Basic Auth no protege /rest)
- ui_noauth.txt: UI sin Basic Auth (esperado: bloqueado / challenge)
- ui_with_basic.txt: UI con Basic Auth (esperado: 200 OK)
