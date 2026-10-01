export function subAdjustInputWidth(input, modifier = 0) {
  input.style.maxWidth = `${(input.value.length || 1) + 2 + modifier}ch`;
}

export function adjustInputWidth(input, modifier = 0) {
  input.addEventListener("input", () => {
    subAdjustInputWidth(input, modifier);
  });
  subAdjustInputWidth(input, modifier);
}

// Controles para mover de posición filas/cartas ordenables (Pj::Ordenado)
export function makePositionBinder(basePath) {
  function visibleOrderedChildren(parent) {
    return Array.from(parent.children).filter(child => child.offsetParent !== null && child.dataset.ordenadoId);
  }

  function swapPosition(parent, beforeElement, afterElement) {
    if (parent && beforeElement && afterElement) {
      parent.insertBefore(afterElement, beforeElement);
      fetch(
        basePath + "/update_field/reorder" +
        "?a=" + beforeElement.dataset.ordenadoId +
        "&b=" + afterElement.dataset.ordenadoId);
    }
  }

  return function bindPositionController(controller) {
    const upButton = document.getElementById(controller.dataset.idPrefix + "-pos_up");
    const downButton = document.getElementById(controller.dataset.idPrefix + "-pos_down");
    const element = document.getElementById(controller.dataset.idPrefix);
    const parent = element.parentElement;

    upButton.addEventListener("click", () => {
      const visible = visibleOrderedChildren(parent);
      const pos = visible.indexOf(element);
      if (pos > 0) {
        swapPosition(parent, visible[pos - 1], element);
      }
    });

    downButton.addEventListener("click", () => {
      const visible = visibleOrderedChildren(parent);
      const pos = visible.indexOf(element);
      if (pos < visible.length - 1) {
        swapPosition(parent, element, visible[pos + 1]);
      }
    });
  };
}
