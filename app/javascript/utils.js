export function subAdjustInputWidth(input, modifier = 0) {
  input.style.maxWidth = `${(input.value.length || 1) + 2 + modifier}ch`;
}

export function adjustInputWidth(input, modifier = 0) {
  input.addEventListener("input", () => {
    subAdjustInputWidth(input, modifier);
  });
  subAdjustInputWidth(input, modifier);
}

function bindOrderButtons(controller, isOrderable, swapFn) {
  const upButton = document.getElementById(controller.dataset.idPrefix + "-pos_up");
  const downButton = document.getElementById(controller.dataset.idPrefix + "-pos_down");
  const element = document.getElementById(controller.dataset.idPrefix);
  const parent = element.parentElement;

  function visibleOrderedSiblings() {
    return Array.from(parent.children).filter(
      child => child.offsetParent !== null && isOrderable(child)
    );
  }

  upButton.addEventListener("click", () => {
    const visible = visibleOrderedSiblings();
    const pos = visible.indexOf(element);
    if (pos > 0) swapFn(parent, visible[pos - 1], element);
  });

  downButton.addEventListener("click", () => {
    const visible = visibleOrderedSiblings();
    const pos = visible.indexOf(element);
    if (pos < visible.length - 1) swapFn(parent, element, visible[pos + 1]);
  });
}

// Persiste el orden al hacer click
export function bindShowPositionController(basePath, controller) {
  bindOrderButtons(
    controller,
    element => !!element.dataset.ordenadoId,
    (parent, beforeElement, afterElement) => {
      parent.insertBefore(afterElement, beforeElement);
      fetch(
        basePath + "/update_field/reorder" +
        "?a=" + beforeElement.dataset.ordenadoId +
        "&b=" + afterElement.dataset.ordenadoId);
    }
  );
}

// No persiste directamente, prepara campo de orden para el formulario
export function bindFormPositionController(controller) {
  bindOrderButtons(
    controller,
    element => !!element.querySelector(".pjv-orden_input"),
    (parent, beforeElement, afterElement) =>{
      parent.insertBefore(afterElement, beforeElement);
      const beforeInput = beforeElement.querySelector(".pjv-orden_input");
      const afterInput = afterElement.querySelector(".pjv-orden_input");
      [beforeInput.value, afterInput.value] = [afterInput.value, beforeInput.value];
    }
  );
}
