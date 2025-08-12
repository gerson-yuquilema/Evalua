export const API_BASE =
  import.meta.env.DEV
    ? "" // en dev, usamos proxy de Vite => /api...
    : ""; // en prod, mismo host

export const PREDICT_URL = `${API_BASE}/api/predict`;
