FROM python:3.12-slim

# SO + libgomp (LightGBM) + Node para construir el frontend
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 curl ca-certificates gnupg tini \
 && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY . .

# Permisos a scripts
RUN chmod +x build.sh dev.sh || true

# Build completo: pip install + npm build + copia a backend/static
RUN ./build.sh

# Asegura uvicorn (si no está en backend/requirements.txt)
RUN python -m pip install --no-cache-dir "uvicorn[standard]"

# Render pasa $PORT; expón por conveniencia
ENV PORT=8000
EXPOSE 8000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "-lc", "cd backend && exec uvicorn app:app --host 0.0.0.0 --port ${PORT:-8000}"]
