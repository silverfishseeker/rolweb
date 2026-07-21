export function warnUnsaved(form) {
  let cantLeave = false;
  
  form.addEventListener("input", () => { cantLeave = true; });

  form.addEventListener("change", () => { cantLeave = true; });

  form.querySelectorAll('input[type="submit"]').forEach(button => {
    button.addEventListener("click", () => { cantLeave = false; });
  });

  window.addEventListener("beforeunload", (event) => { // Aviso al cerrar pestaña, recargar o navegar fuera
    if (cantLeave) {
      event.preventDefault();
      event.returnValue = "";
    }
  });
  
  document.addEventListener("turbo:before-visit", (event) => { // Navegación Turbo (links internos)
    if (cantLeave && !confirm( "Tienes cambios sin guardar. ¿Seguro que quieres salir de esta página?" ))
        event.preventDefault();
  });
}