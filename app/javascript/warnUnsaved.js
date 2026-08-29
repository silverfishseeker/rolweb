let cantLeave;
let currentBeforeUnloadListener = null;
let currentTurboVisitListener = null;

export function markUnsaved() {
  cantLeave = true;
}

export function warnUnsaved(form) {
  cantLeave = false;

  form.addEventListener("input", () => { cantLeave = true; });
  form.addEventListener("change", () => { cantLeave = true; });

  form.querySelectorAll('input[type="submit"]').forEach(button => {
    button.addEventListener("click", () => {
      cantLeave = false;
    });
  });

  // Con turbo no se quitan los listeners al navegar, los quitamos si hay uno anterior
  if (currentBeforeUnloadListener) window.removeEventListener("beforeunload", currentBeforeUnloadListener);
  if (currentTurboVisitListener) document.removeEventListener("turbo:before-visit", currentTurboVisitListener);

  currentBeforeUnloadListener = (event) => { // Aviso al cerrar pestaña, recargar o navegar fuera
    if (cantLeave) {
      event.preventDefault();
    }
  };

  currentTurboVisitListener = (event) => { // Navegación Turbo (links internos)
    if (cantLeave && !confirm( "Tienes cambios sin guardar. ¿Seguro que quieres salir de esta página?" ))
      event.preventDefault();
  };

  window.addEventListener("beforeunload", currentBeforeUnloadListener);
  document.addEventListener("turbo:before-visit", currentTurboVisitListener);
}
