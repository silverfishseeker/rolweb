
import { adjustInputWidth } from "./utils.js";
import { initTabs } from "./tabs.js";
import { warnUnsaved, markUnsaved } from "./warnUnsaved.js";
import { createCloseModalHandler } from "./modals.js";


// --- Gestión de ítems del inventario: eliminar / restaurar / crear personalizado ---

// Sistema de secuencias para evitar que se procesen acciones de ítems obsoletas
const itemActionSeq = new Map(); // phiId (string) -> último seq usado
window.nextItemSeq = function (phiId) {
  const seq = (itemActionSeq.get(phiId) || 0) + 1;
  itemActionSeq.set(phiId, seq);
  return seq;
};
window.isStaleItemSeq = function (phiId, seq) {
  const current = itemActionSeq.get(phiId);
  return current !== undefined && Number(seq) < current;
};

window.setItemCardState = function (card, isDeleted) {
  card.classList.toggle("pj-fila_borrada", isDeleted);
  card.querySelectorAll("input, select, textarea, button").forEach(el => {
    el.disabled = isDeleted;
  });
  card.querySelector(`#${card.id}-eliminar`).hidden = isDeleted;
  card.querySelector(`#${card.id}-restaurar`).hidden = !isDeleted;
};

// Busca el item en el inventario y el equipado
window.setItemCardStateToBoth = function(card, isDeleted) {
  const phiId = card.id.match(/-(\d+)$/)[1];
  const card_equipped = document.getElementById(`phi-${phiId}`);
  const card_inventory = document.getElementById(`phi_iinv-${phiId}`);
  if (card_equipped) window.setItemCardState(card_equipped, isDeleted);
  if (card_inventory) window.setItemCardState(card_inventory, isDeleted);
}

export function onTurboLoad() {

  // Aviso de cambios sin guardar
  warnUnsaved(document.querySelector(".pjv-form"));


  // Autoguardado
  document.addEventListener("input", (e) => {
    const input = e.target;
    if (input.classList.contains("autosave-input")) {
      fetch(input.dataset.updateUrl+"?value="+encodeURIComponent(input.value));
    }
  });


  // Data modifiers
  document.addEventListener("input", (e) => {
    const input = e.target;
    if (input.classList.contains("pjv-modifier")) {
      adjustInputWidth(input, 1);
      const base  = Number(document.getElementById(input.dataset.base).innerHTML);
      const value = document.getElementById(input.dataset.value);
      const mod = Number(input.value)
      const result =  base + mod;
      value.innerHTML = result;
      if ("mod" in input.dataset) {
        const mod = document.getElementById(input.dataset.mod);
        const new_mod = Math.floor(result / 2 - 5);
        if (new_mod > 0)
          mod.innerHTML ="+" + new_mod;
        else
        mod.innerHTML =new_mod;
      }
    };
  });

  // Resizable columns
  const styles = getComputedStyle(document.documentElement);
  const MIN_WIDTH = parseInt(styles.getPropertyValue("--pjv-columns-min-width"));
  const MIN_TOTAL_WIDTH = parseInt(styles.getPropertyValue("--pjv-columns-min-total-width"));
  document.querySelectorAll(".pjv-resizer").forEach( resizer => {
    const left = resizer.previousElementSibling;
    const right = resizer.nextElementSibling;
    let x = 0;

    resizer.addEventListener("mousedown", (e) => {
      x = e.clientX;
      document.addEventListener("mousemove", mouseMove);
      document.addEventListener("mouseup", mouseUp);
    });

    const mouseMove = function(e) {
      const dx = e.clientX - x;
      let leftWidth = left.offsetWidth + dx;
      let rightWidth = right.offsetWidth - dx;
      if (leftWidth < MIN_WIDTH || rightWidth < MIN_WIDTH) return;
      left.style.flex = `0 0 ${leftWidth}px`;
      right.style.flex = `0 0 ${rightWidth}px`;
      x = e.clientX;
    };

    const mouseUp = function() {
      document.removeEventListener("mousemove", mouseMove);
      document.removeEventListener("mouseup", mouseUp);
    };
  });

  // Reajustar ancho columnas proporcionalmente al cambiar el tamaño de la ventana
  // Es complejo porque aplicamos un ancho mínimo.
  function adjustColumns() {
    const columns = document.querySelectorAll(".pjv-column");
    if (window.innerWidth < MIN_TOTAL_WIDTH) {
      columns.forEach( column => {
        column.style.flex = "1";
      });
      return;
    }
    
    let prevTotalWidth = 0;
    let newTotalWidth = document.querySelector(".pjv-columns").offsetWidth - 30; // 30px de los dos resizers y gaps
    let columns_with_widths = [];

    columns.forEach( column => {
      columns_with_widths.push([column, column.offsetWidth]);
      prevTotalWidth += column.offsetWidth;
    });

    let changed = true;
    while (changed) {
      changed = false;
      for (let i = columns_with_widths.length - 1; i >= 0; i--) {
        const [column, width] = columns_with_widths[i];
        const new_width = Math.floor((width / prevTotalWidth) * newTotalWidth);
        if (new_width < MIN_WIDTH) {
          columns_with_widths.splice(i, 1);
          column.style.flex = `0 0 ${MIN_WIDTH}px`;
          prevTotalWidth -= width;
          newTotalWidth -= MIN_WIDTH;
          changed = true;
        } else {
          columns_with_widths[i][1] = new_width;
        }
      }
    }
    
    columns_with_widths.forEach( ([column, width]) => {
      column.style.flex = `0 0 ${width}px`;
    });
  };
  window.addEventListener("resize", () => {
    adjustColumns();
  });
  adjustColumns(); // Ajustar al cargar la página

  //tabs de la columna central
  initTabs(document.querySelector('.pjv-column-tabs'));

  // Ajustar ancho input cantidad
  document.querySelectorAll(".pj-cantidad").forEach(input => {
    adjustInputWidth(input);
  });


  // Controles para mover de posición las cartas
  function swapPosition(parent, beforeElement, afterElement) {
    if (parent && beforeElement && afterElement) {
      parent.insertBefore(afterElement, beforeElement);
      const beforeElementPosition = document.getElementById(beforeElement.id + "-position");
      const afterElementPosition = document.getElementById(afterElement.id + "-position");
      const temp = beforeElementPosition.value;
      beforeElementPosition.value = afterElementPosition.value;
      afterElementPosition.value = temp;
      markUnsaved();
    }
  }
  function visibleChildren(parent) {
    return Array.from(parent.children).filter(child => child.offsetParent !== null);
  }
  // Botones de mover posición
  document.querySelectorAll(".pjv-pos_controller").forEach( controller => {
    const upButton = document.getElementById(controller.dataset.idPrefix + "-pos_up");
    const downButton = document.getElementById(controller.dataset.idPrefix + "-pos_down");
    const element = document.getElementById(controller.dataset.idPrefix);
    const parent = element.parentElement;


    upButton.addEventListener("click", () => {
      const visible = visibleChildren(parent);
      const pos = visible.indexOf(element);
      if (pos > 0) {
        swapPosition(parent, visible[pos - 1], element);
      }
    });

    downButton.addEventListener("click", () => {
      const visible = visibleChildren(parent);
      const pos = visible.indexOf(element);
      if (pos < visible.length - 1) {
        swapPosition(parent, element, visible[pos + 1]);
      }
    });
  });

  //Filtrar intems por categoría
  let currentlySelected = [];
  const categorySelect = document.getElementById("inventario-selection");
  categorySelect.querySelectorAll(".inventario-categ").forEach( categ => {
    categ.addEventListener("click", () => {
      const categValue = categ.dataset.categ;
      if (currentlySelected.includes(categValue)) {
        currentlySelected = currentlySelected.filter(v => v !== categValue);
        categ.classList.remove("carta-title-selected");
      } else {
        currentlySelected.push(categValue);
        categ.classList.add("carta-title-selected");
      }
      const items = document.getElementById("inventario-items").querySelectorAll(".inventario-item");
      if (currentlySelected.length === 0) {
        items.forEach( item => {
          item.style.display = "block";
        });
      } else {
        items.forEach( item => {
          const itemCategories = item.dataset.categs.split(",");
          if (currentlySelected.every( cat => itemCategories.includes(cat))) {
            item.style.display = "block";
          } else {
            item.style.display = "none";
          }
        });
      }
    });
  });

  // Quitar ítems marcados como borrados al cerrar el modal.
  document.getElementById("inventario-selection").closest(".modal-container")
    .addEventListener("click", createCloseModalHandler(() => {
      document.querySelectorAll("#inventario-items .pj-fila_borrada, #tab-equipo .pj-fila_borrada")
        .forEach(card => card.remove());
    }));
}