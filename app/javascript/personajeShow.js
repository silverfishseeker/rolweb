
import { adjustInputWidth } from "./utils.js";

export function onTurboLoad() {
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
  const MIN_WIDTH = 230;
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
  window.addEventListener("resize", () => {
    const columns = document.querySelectorAll(".pjv-column");
    if (window.innerWidth < 768) { // No reajustar en móvil. mismo valor que en respond-max
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
  });


  // Actualizar parámetro del link de aumentar/disminuir salud al cambiar el modificador activo
  function updateLinkParam(link, param, value) {
    const url = new URL(link.href);
    url.searchParams.set(param, value);
    link.href = url.toString();
  }

  document.addEventListener("input", (e) => {
    const input = e.target;
    if (input.classList.contains("pjv-modifier-armadura")) {
      const aumentar_link = document.getElementById(input.dataset.linkAumentarId);
      const disminuir_link = document.getElementById(input.dataset.linkDisminuirId);
      updateLinkParam(aumentar_link, "active_mod", input.value);
      updateLinkParam(disminuir_link, "active_mod", input.value);
    }
  });
}