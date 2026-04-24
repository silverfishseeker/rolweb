import { nextZIndex } from "./zIndexCounter.js";

export function onTurboLoad() {
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