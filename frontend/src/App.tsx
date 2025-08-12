// frontend/src/App.tsx
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import { TooltipProvider } from "@/components/ui/tooltip";
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";

// Componentes de tu app
import Hero from "./components/Hero";
import FileUpload from "./components/FileUpload";
import EvaluationFlow from "./components/EvaluationFlow";
import Dashboard from "./components/Dashboard";

const queryClient = new QueryClient();

//prueba
// Home compuesto (pantalla principal)
function Home() {
  return (
    <div className="space-y-8">
      <Hero />
      <FileUpload />
      <EvaluationFlow />
    </div>
  );
}

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
            {/* Pantalla principal */}
            <Route path="/" element={<Home />} />

            {/* Dashboard en ruta aparte */}
            <Route path="/dashboard" element={<Dashboard />} />

            {/* Cualquier otra ruta redirige al home */}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </BrowserRouter>
      </TooltipProvider>
    </QueryClientProvider>
  );
}
