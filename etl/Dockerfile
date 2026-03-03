FROM python:3.11-slim

WORKDIR /app

# Copy requirements
COPY etl/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy all ETL source code
COPY etl/*.py .
COPY etl/chilecompra ./chilecompra
COPY etl/dw ./dw
COPY etl/sql_templates ./sql_templates

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]


