/**IMPORTANTE:
 * Cuando este JavaScript es importado, es OBLIGATORIO renderizar también
 * nuevoestadoalterado-template ubicado en app/views/personajes/_estadoalterado-template.html.erb
 */

import { createCloseModalHandler  }  from "./modals.js";

export function onTurboLoad() {

  // Añadir estado alterado
  function addEstadoalterado(css_class, template_name) {
    document.getElementById("tab-estado").addEventListener("click", e => { // Este no lo podemos restringir en pc_body para que funcione para los estados alterados generales
      if (e.target.classList.contains(css_class)) {
        const button = e.target;
        const tableId = button.dataset.table_id;
        const nombreInputBase = button.dataset.nombreInputBase;
        const tbody = document.querySelector(`#${tableId} tbody`);
        const template = document.getElementById(template_name).innerHTML
          .replace(/__id__/g, tbody.querySelectorAll('tr').length)
          .replace(/__nombre_input_base__/g, nombreInputBase);
        tbody.insertAdjacentHTML('beforeend', template);
      }
    });
  }
  addEstadoalterado("add-estadoalterado", "estadoalterado-template");
  addEstadoalterado("add-estadoalterado-libre", "estadoalterado-template-libre");

  // Resumen estados alterados
  function estadosalterados_summary(table, target_writting) {
    const tbody = table.querySelector('tbody');
    const estados = Array.from(tbody.querySelectorAll('tr'))
    .filter(tr => ! tr.querySelector('input[name$="[_destroy]"]').checked
    ).map(tr => {
      const libre = tr.querySelector('input[name$="[libre]"]')
      if (libre) return libre.value;
      const nombreTd = tr.querySelector('td[data-label="Estado"]');
      const select = nombreTd.querySelector('select');
      const valorInput = tr.querySelector('td[data-label="Valor"] input');
      let nombre;
      let isNumeric;
      if (select) {
        const option = select.options[select.selectedIndex];
        nombre = option.text;
        isNumeric = option.dataset.isNumeric === 'true';
      } else {
        nombre = nombreTd.textContent.trim();
        isNumeric = valorInput !== null;
      }
      return isNumeric ? `${nombre} ${valorInput.value}` : nombre;
    });
    target_writting.textContent = estados.join(', ');
  }

  // Preparar resúmenes de estados alterados en carga
  document.querySelectorAll('.estado-resumen').forEach(resumen => {
    const table = document.querySelector(`#${resumen.dataset.table_id}`);
    estadosalterados_summary(table, resumen);
  });

  const pc_body = document.getElementById("parte-cuerpos-body");

  // Modal estados alterados parte cuerpo
  pc_body.addEventListener("click", createCloseModalHandler((modal, index, classList) => {
    if (classList.contains("modal-close-resumen")) {
      const table = modal.querySelector('table');
      const target_writting = document.getElementById("resumen-" + index);
      estadosalterados_summary(table, target_writting);
    }
  }));
}