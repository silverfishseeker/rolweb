import { nextZIndex } from "./zIndexCounter.js";

// Abrir modal
function openModal(e) {
  const button = e.target.closest(".open_modal");
  if (button) {
    const style = document.getElementById(button.dataset.index).style
    style.display = "block";
    style.zIndex = nextZIndex();
  }
}

// Cerrar modal
export function createCloseModalHandler(extraAction = () => {}) {
  return function(e) {
    if (e.target.classList.contains("modal-close")) {
      const index = e.target.dataset.index;
      const modal = document.getElementById(e.target.dataset.index);
      modal.style.display = "none";
      extraAction(modal, index, e.target.classList);
    }
  }
}

export function onTurboLoad() {
  // Default open/close modals based on data attribute
  document.querySelectorAll(".modal-container").forEach(container => {
    container.addEventListener("click", openModal);
    if (container.dataset.defaultClose === "true") {
      container.addEventListener("click", createCloseModalHandler());
    }
  });

  // Modal dragging and send to front on click
  document.querySelectorAll(".pj-modal").forEach(modal => {
    const header = modal.querySelector("header");
    let isDragging = false;
    let offsetX, offsetY;

    modal.addEventListener("click", (e) => {
      modal.style.zIndex = nextZIndex();
    });

    header.addEventListener("mousedown", (e) => {
      isDragging = true;
      const rect = modal.getBoundingClientRect();
      modal.style.left = `${rect.left}px`;
      modal.style.top = `${rect.top}px`;
      modal.style.transform = "none";
      offsetX = e.clientX - rect.left;
      offsetY = e.clientY - rect.top;
      modal.classList.add("dragging");
    });

    document.addEventListener("mousemove", (e) => {
      if (isDragging) {
        modal.style.left = `${e.clientX - offsetX}px`;
        modal.style.top = `${e.clientY - offsetY}px`;
      }
    });

    document.addEventListener("mouseup", () => {
      isDragging = false;
      modal.classList.remove("dragging");
    });
  });
}