let currentBeforeUnloadListener = null;
let currentTurboVisitListener = null;

export function warnUnsaved(form) {
  let cantLeave = false;
  const markDirty = () => { cantLeave = true; };

  form.addEventListener("input", markDirty);
  form.addEventListener("change", markDirty);
  const observer = new MutationObserver(markDirty);
  observer.observe(form, { childList: true, subtree: true });

  form.querySelectorAll('input[type="submit"]').forEach(button => {
    button.addEventListener("click", () => {
      cantLeave = false;
      observer.disconnect();
    });
  });

  // Si ya había un listener, lo eliminamos para evitar duplicados. (turbo no recarga la página)
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
