let cantLeave;
let currentBeforeUnloadListener = null;
let currentTurboVisitListener = null;

export function markUnsaved() {
  cantLeave = true;
}

// setup recibe un setter y engancha sus propios listeners para llamarlo cuando corresponda
export function warnUnsaved(setup) {
  cantLeave = false;

  setup((value) => { cantLeave = value; });

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
