export function onTurboLoad() {
  // wrap en el menú de tabs
  const form = document.querySelector('.pj-form');
  const tabs = document.querySelector('.pj-tabs');
  const nav = document.querySelector('.pj-tabs-nav');
  new ResizeObserver(() => {
    const y = nav.firstElementChild.offsetTop;
    if (Array.from(nav.children).some(el => el.offsetTop > y)) {
      form.insertBefore(nav, tabs);
      tabs.classList.add('wrapped');
      nav.classList.add('wrapped');
    } else {
      tabs.appendChild(nav);
      tabs.classList.remove('wrapped');
      nav.classList.remove('wrapped');
    }
  }).observe(nav);

  // Tabs
  document.querySelectorAll('.pj-tabs-nav div').forEach(function(a){
    a.addEventListener('click', function(e){
      document.querySelectorAll('.pj-tabs-nav div').forEach(li => li.classList.remove('pj-tabs-nav-active'));
      this.classList.add('pj-tabs-nav-active');
      document.querySelectorAll('.pj-tab_pane').forEach(tp => tp.classList.remove('pj-tab_pane-active'));
      document.querySelector(this.getAttribute("data_tab_target")).classList.add('pj-tab_pane-active');
    });
  });

  // Toggle rango (delegado)
  const c_body = document.getElementById("calculados-body");
  function toggleRango(button) {
    const input = button.closest("tr").querySelector(".rango-input");
    if (input) input.disabled = !input.disabled;
  }
  c_body.addEventListener("click", e => {
    if (e.target.classList.contains("toggle-rango")) {
      toggleRango(e.target);
    }
  });

  // Añadir calculado libre
  document.getElementById("add-calculado-libre").addEventListener("click", () => {
    const index = c_body.querySelectorAll("tr[data-index]").length;
    const template = document.getElementById("calculado-libre-template");
    const html = template.innerHTML.replace(/__INDEX__/g, index);
    const addRow = document.getElementById("add-calculado-libre").closest("tr");
    addRow.insertAdjacentHTML("beforebegin", html);
  });
  
  // Añadir estado alterado
  document.getElementById("tab-estado").addEventListener("click", e => { // Este no lo podemos restringir en pc_body para que funcione para los estados alterados generales
    if (e.target.classList.contains("add-estadoalterado")) {
      const button = e.target;
      const tableId = button.dataset.table_id;
      const nombreInputBase = button.dataset.nombreInputBase;
      const tbody = document.querySelector(`#${tableId} tbody`);
      const template = document.getElementById('estadoalterado-template').innerHTML
        .replace(/__id__/g, tbody.querySelectorAll('tr').length)
        .replace(/__nombre_input_base__/g, nombreInputBase);
      tbody.insertAdjacentHTML('beforeend', template);
    }
  });



  // PARTES CUERPO
  const pc_body = document.getElementById("parte-cuerpos-body");


  // Toggle mapeo parte cuerpo
  pc_body.addEventListener("click", e => {
    const button = e.target;
    if (!button.classList.contains("open-mapeo-parte")) return
    const index = button.getAttribute("index");
    const td = button.closest('td');
    const inputText = td.querySelector(`#mapeo-input-${index}`);
    const inputIsMapeo = td.querySelector(`#mapeo-isMapeo-${index}`);

    if (inputIsMapeo.value == "0"){
      button.textContent = "Editar";
      inputText.style.display = "block";
      inputText.disabled = false;
      inputIsMapeo.value = "1";
    } else {
      button.textContent = "Por defecto";
      inputText.style.display = "none";
      inputText.disabled = true;
      inputIsMapeo.value = "0";
    }
  });

  // Resumen estados alterados
  function estadosalterados_summary(table, target_writting) {
    const tbody = table.querySelector('tbody');
    const estados = Array.from(tbody.querySelectorAll('tr'))
    .filter(tr => ! tr.querySelector('input[name$="[_destroy]"]').checked
    ).map(tr => {
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

  // Abrir modal,check: _form_modal.html.erb
  pc_body.addEventListener("click", e => {
    if (e.target.classList.contains("open-modal")) {
      document.getElementById(e.target.dataset.index).style.display = "block";
    }
  });

  // Cerrar modal, check: _form_modal.html.erb
  pc_body.addEventListener("click", e => {
    if (e.target.classList.contains("modal-close")) {
      const index = e.target.dataset.index;
      const modal = document.getElementById(e.target.dataset.index);
      modal.style.display = "none";
      
      if (modal.classList.contains("pj-modal_partecuerpo_estadosalterados")) {
        const table = modal.querySelector('table');
        const target_writting = document.getElementById("resumen-" + index);
        estadosalterados_summary(table, target_writting);
      }
    }
  });

  // Añadir parte cuerpo
  document.getElementById("add-parte-cuerpo").addEventListener("click", () => {
    const index = document.getElementById("parte-cuerpos-table").rows.length-2; // -2 para no contar header y fila de template
    const template = document.getElementById("parte-cuerpo-template");
    const html = template.innerHTML.replace(/__INDEX__/g, index);
    const addRow = document.getElementById("parte-cuerpos-next");
    addRow.insertAdjacentHTML("beforebegin", html);
  });

  // Mover clase
  document.getElementById("clases-section").querySelectorAll(".carta-add_buttom").forEach(button => {
    button.addEventListener("click", () => {
      const carta = document.getElementById(`clase_${button.dataset.claseId}`);
      const destroyInput = carta.querySelector(`input[name$="[_destroy]"]`);
      if (destroyInput.value === "1") {
        destroyInput.value = "0";
        button.textContent = "-";
        document.getElementById("clases_container_0").prepend(carta);
      } else {
        destroyInput.value = "1";
        button.textContent = "+";
        document.getElementById("clases_container_1").prepend(carta);
      }
    });
  });
}