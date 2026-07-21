
import { adjustInputWidth } from "./utils.js";
import { initTabs } from "./tabs.js";
import {warnUnsaved } from "./warnUnsaved.js";

export function onTurboLoad() {

  // Aviso de cambios sin guardar
  warnUnsaved(document.querySelector(".pjv-form"));


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

  // Estilo de filas borradas cuando la salud es 0 o menos
  document.querySelectorAll(".pjv-var-cuerpo").forEach( pc => {
    pc.addEventListener("turbo:frame-load", (event) => {
      const frame = event.target;
      const saludAct_span = frame.querySelector(".pjv-var-cuerpo-act");
      const saludAct = parseInt(saludAct_span.innerHTML);
      if (saludAct <= 0) {
        pc.classList.add("pjv-var-cuerpo-borrada");
      } else {
        pc.classList.remove("pjv-var-cuerpo-borrada");
      }
    });
  });

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
  const items =  document.getElementById("inventario-items").querySelectorAll(".inventario-item");
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

  //Añadir item custom
  let nextCustomItemId = 1;
  document.getElementById("new-customitem-buttom").addEventListener("click", event => {
    const template = document.getElementById("customitem-template");
    const html = template.innerHTML.replaceAll("__ID__",nextCustomItemId++);
    document .getElementById("inventario-items").insertAdjacentHTML("beforeend", html);
  });

  //Marcar items a borrar
  document.addEventListener("change", e => {
    if (e.target.classList.contains("rm_input")) {
      const input = e.target;
      const carta = input.closest(".carta");
      if (input.checked)
        carta.classList.add("pj-fila_borrada");
      else
        carta.classList.remove("pj-fila_borrada");
    }
  });
}