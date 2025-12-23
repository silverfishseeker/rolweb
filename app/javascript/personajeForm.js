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
  document.querySelectorAll('.add-estadoalterado').forEach(button => {
    button.addEventListener('click', () => {
      const tableId = button.getAttribute('table_id');
      const tbody = document.querySelector(`#${tableId} tbody`);
      const templateElement = document.getElementById('estadoalterado-template');
      const nombreInputBase = "has_estadoalterados";
      const template = templateElement.innerHTML
        .replace(/__id__/g, tbody.querySelectorAll('tr').length)
        .replace(/__nombre_input_base__/g, nombreInputBase);
      tbody.insertAdjacentHTML('beforeend', template);
    });
  });

  // Toggle mapeo parte cuerpo
  const pc_body = document.getElementById("parte-cuerpos-body");
  pc_body.addEventListener("click", e => {
    if (e.target.classList.contains("open-mapeo-parte")) {
      const id = e.target.getAttribute("index");
      const input = pc_body.querySelector('#estadoalterado-template');
      if (isHidden = input.style.display === "none"){
        e.target.textContent = "Editar";
        input.style.display = "block";
      } else {
        e.target.textContent = "Por defecto";
        input.style.display = "none";
      }
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
    const table_id = "table_" + resumen.getAttribute('index');
    const table = document.querySelector(`#${table_id}`);
    estadosalterados_summary(table, resumen);
  });

  // Abrir modal de estados alterados
  pc_body.addEventListener("click", e => {
    if (e.target.classList.contains("open-estados-parte")) {
      const modal = document.getElementById("modal-estadosalterados-parte-" + e.target.getAttribute("index"));
      modal.style.display = "block";
    }
  });

  // Cerrar modal de estados alterados
  pc_body.addEventListener("click", e => {
    if (e.target.classList.contains("modal-close")) {
      const index = e.target.getAttribute("index");
      const modal = document.getElementById("modal-estadosalterados-parte-" + index);
      modal.style.display = "none";
      const table = modal.querySelector('table');
      const target_writting = pc_body.querySelector(`.estado-resumen[index="${index}"]`);
      estadosalterados_summary(table, target_writting);
    }
  });

  // Añadir parte cuerpo
  document.getElementById("add-parte-cuerpo").addEventListener("click", () => {
    const index = pc_body.querySelectorAll("tr[data-index]").length;
    const template = document.getElementById("parte-cuerpo-template");
    const html = template.innerHTML.replace(/__INDEX__/g, index);
    const addRow = document.getElementById("parte-cuerpos-next");
    addRow.insertAdjacentHTML("beforebegin", html);
  });

}