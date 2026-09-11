// Aviso de estado de guardado para personaje show.
import { warnUnsaved } from "./warnUnsaved.js";

let pendingCount = 0;
let indicator = null;
let listenersAttached = false;
let setCantLeave = null;

export function refreshSaveStatus() {
  const dirty = document.querySelector(".autosave-trix").dataset.dirty === "1";
  setCantLeave(dirty || pendingCount > 0);
  if (dirty) {
    indicator.textContent = "Cambios pendientes en las notas";
    indicator.hidden = false;
  } else if (pendingCount > 0) {
    indicator.textContent = "Guardando...";
    indicator.hidden = false;
  } else {
    indicator.hidden = true;
  }
}

export function initSaveStatus(indicatorEl) {
  indicator = indicatorEl;

  // Wrap fetch to track pending updates
  if (!window.fetch.__saveStatusWrapped) {
    const originalFetch = window.fetch;
    window.fetch = function (url, ...rest) {
      if (typeof url === "string" && url.includes("/update_field/")) {
        pendingCount++;
        refreshSaveStatus();
      }
      return originalFetch.call(this, url, ...rest);
    };
    window.fetch.__saveStatusWrapped = true;
  }

  if (!listenersAttached) {
    document.addEventListener("turbo:before-stream-render", () => {
      pendingCount = Math.max(0, pendingCount - 1); // Some fetches result in multiple streams (it is not an issue if we suposed the rest of saved in cases of stacked fetches)
      refreshSaveStatus();
    });
    document.addEventListener("trix-change", refreshSaveStatus);
    listenersAttached = true;
  }

  warnUnsaved((setter) => { setCantLeave = setter; });

  refreshSaveStatus();
}
