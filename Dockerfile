# ===== Imagen única con Python + Node =====
FROM python:3.12-slim

# --- SO base + Node ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg tini \
 && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Copiamos todo el repo (usa .dockerignore si tienes archivos pesados)
COPY . .

# Asegura que los scripts se puedan ejecutar
RUN chmod +x build.sh dev.sh || true

# --- BUILD del proyecto usando TU build.sh ---
# Esto instala requirements, hace npm ci/build y copia frontend/dist a backend/static
RUN ./dev.sh

# Asegúrate de que uvicorn esté disponible (si no viene en requirements.txt)
RUN python -m pip install --no-cache-dir "uvicorn[standard]"

# Render inyecta PORT. Si no está, usa 8000.
ENV PORT=8000
EXPOSE 8000

# Tini para manejar señales correctamente
ENTRYPOINT ["/usr/bin/tini", "--"]

# Ejecuta el backend (FastAPI) sirviendo el build estático que quedó en backend/static
CMD ["bash", "-lc", "cd backend && exec uvicorn app:app --host 0.0.0.0 --port ${PORT:-8000}"]
