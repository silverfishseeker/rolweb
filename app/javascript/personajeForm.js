import { adjustInputWidth, subAdjustInputWidth } from "./utils.js";
import { createCloseModalHandler, initModals }  from "./modals.js";
import { initTabs } from "./tabs.js";
import { warnUnsaved } from "./warnUnsaved.js";

export function onTurboLoad() {

  const form = document.querySelector(".pj-form");

  // Siempre se avisa al salir, sin comprobar si hay cambios reales de por medio.
  warnUnsaved((setCantLeave) => {
    setCantLeave(true);
    form.querySelector('input[type="submit"]').addEventListener("click", () => setCantLeave(false));
  });

  //tabs
  initTabs(form);

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


  // Marcar/desmarcar filas borradas
  form.addEventListener("change", e => {
    if (e.target.classList.contains("rm_input")) {
      const input = e.target;
      const row = input.closest("tr");
      const type = input.dataset.rm_type == "1"
      if (input.checked == type)
        row.classList.remove("pj-fila_borrada");
      else
        row.classList.add("pj-fila_borrada");
    }
  });

  // NIVELES
  const tabla_niveles = document.getElementById("pj-niveles-table");
  tabla_niveles.querySelectorAll("input").forEach(input => {
    adjustInputWidth(input);
  });

  tabla_niveles.querySelectorAll("tr").forEach(tr =>{
    const button = tr.querySelector("button");
    if(button){
      const copy_from = tr.querySelector(".calculado");
      const copy_to = tr.querySelector("input");
      button.addEventListener("click", () => {
        copy_to.value = copy_from.textContent.trim();
      });
    }
  });

  // ESTADO

  // Añadir calculado libre
  document.getElementById("add-calculado-libre").addEventListener("click", () => {
    const index = c_body.querySelectorAll("tr[data-index]").length;
    const template = document.getElementById("calculado-libre-template");
    const html = template.innerHTML.replace(/__INDEX__/g, index);
    const addRow = document.getElementById("add-calculado-libre").closest("tr");
    addRow.insertAdjacentHTML("beforebegin", html);
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


  // Añadir parte cuerpo
  document.getElementById("add-parte-cuerpo").addEventListener("click", () => {
    const index = document.getElementById("parte-cuerpos-table").rows.length-2; // -2 para no contar header y fila de template
    const template = document.getElementById("parte-cuerpo-template");
    const html = template.innerHTML.replace(/__INDEX__/g, index);
    const addRow = document.getElementById("parte-cuerpos-next");
    addRow.insertAdjacentHTML("beforebegin", html);
  });


  // CLASES, HABILIDADES, ITEMS

  // Lazy loading of sections (clases, habilidades, items)
  const basePath = form.dataset.basePath;
  async function loadSectionInto(element, section, targetId) {
    element.innerHTML = await (await fetch(
      `${basePath}/form_lazy_section/${section}` + (targetId != null ? `/${targetId}` : "")
    )).text();
    initModals(element); // El HTML recién insertado no pasó por el arranque de la página
    element.querySelectorAll(".pj-cantidad").forEach(input => subAdjustInputWidth(input));
  }

  //Mover carta genérico
  function moveCarta(button, aliveContainer, destroyContainer) {
    const carta = document.getElementById(button.dataset.carta_id);
    const destroyInput = carta.querySelector(`input[name$="[_destroy]"]`);
    if (destroyInput.value === "1") {
      carta.disabled = false;
      destroyInput.value = "0";
      button.textContent = "-";
      aliveContainer.prepend(carta);
    } else {
      destroyInput.value = "1";
      button.textContent = "+";
      destroyContainer.prepend(carta);
    }
  }

  // Mover clase/habilidad/ítem (delegado)
  function attachMoveCartaDelegation(container) {
    container.addEventListener("click", e => {
      const button = e.target.closest(".carta-add_buttom");
      if (!button) return;
      const aliveContainer = document.getElementById(button.dataset.alive_container);
      const destroyContainer = document.getElementById(button.dataset.destroy_container);
      moveCarta(button, aliveContainer, destroyContainer);
    });
  }

  // Modal sobreescritura clase, habilidad e ítem (delegado)
  function modalHandelers(container) {
    container.addEventListener("click", createCloseModalHandler((_, id, classList) => {
      if (classList.contains("modal-close-sobreescritura")) {
        // reemplazar texto de efecto por la sobreescritura en la carta
        const div_efecto = document.getElementById(`efecto-${id}`);
        const input_sobrreescritura = document.getElementById(`sobreescritura-${id}`);
        div_efecto.innerHTML = input_sobrreescritura.value;
      }
    }));

    // Reseteo texto sobreescritura clase o habilidad
    container.addEventListener("click", e => {
      if (e.target.classList.contains("boton_reseteo_texto")) {
        const id = e.target.dataset.id;
        const original_efecto = document.getElementById(`original-efecto-${id}`).innerHTML;
        const trix_editor = document.querySelector(`#sobreescritura-modal-${id} ~ trix-editor`);
        trix_editor.editor.loadHTML(original_efecto);
      }
    });
  }

  // Toggle rango contador clase/habilidad (delegado)
  function addToggleRangoListener(container) {
    container.addEventListener("click", e => {
      if (e.target.classList.contains("toggle-rango")) {
        toggleRango(e.target);
      }
    });
  }

  // Abrir lista genérica (menú -> lista), con carga diferida opcional de la lista
  function selectListFromMenu(containerMenu, matchClass, selectedClass, listsScopeSelector, loadList) {
    containerMenu.addEventListener("click", async e => {
      const button = e.target.closest(`.${matchClass}`);
      if (!button) return;

      const target = document.getElementById(button.dataset.list);

      if (loadList && target.dataset.loaded !== "1") {
        target.dataset.loaded = "1";
        await loadList(target, button);
      }

      document.querySelector(listsScopeSelector).querySelectorAll(".pj-selected_list").forEach(l => {
        l.classList.remove("pj-selected_list-active");
      });
      containerMenu.querySelectorAll(`.${matchClass}`).forEach(b => {
        b.classList.remove(`${selectedClass}-selected`);
      });
      target.classList.add("pj-selected_list-active");
      button.classList.add(`${selectedClass}-selected`);
    });
  }


  // CLASES Y HABILIDADES
  const tabClases = document.getElementById("tab-clases");

  attachMoveCartaDelegation(tabClases);
  modalHandelers(tabClases);
  addToggleRangoListener(tabClases);

  // Reseteo clase de habilidad (delegado)
  tabClases.addEventListener("click", e => {
    if (e.target.classList.contains("boton_reseteo_clase")) {
      const select = document.getElementById(e.target.dataset.id_select);
      select.value = e.target.dataset.id_clase;
    }
  });

  // Abrir lista habilidades clase, cargando esa clase la primera vez que se abre
  selectListFromMenu(tabClases, "carta_form_clase", "carta_form_clase", "#habilidades-section",
    target => loadSectionInto(
      target.querySelector(".habilidades-list-content"),
      "habilidades_for_clase",
      target.dataset.clase_id));

  // Carga diferida de la pestaña (clases + esqueleto de habilidades por clase)
  const tabClasesNav = document.querySelector('[data_tab_target="#tab-clases"]');
  const tabClasesContent = document.getElementById("tab-clases-content");
  tabClasesNav.addEventListener("click", () => {
    if (tabClasesContent.dataset.loaded === "1") return;
    tabClasesContent.dataset.loaded = "1";
    loadSectionInto(tabClasesContent, "clases_tab");
  });


  // ITEMS
  const tabItems = document.getElementById("tab-items");

  modalHandelers(tabItems);
  attachMoveCartaDelegation(tabItems);
  addToggleRangoListener(tabItems);

  // Ajustar ancho input cantidad (inicial + al escribir), incluidos los que se carguen luego
  tabItems.querySelectorAll(".pj-cantidad").forEach(input => subAdjustInputWidth(input));
  tabItems.addEventListener("input", e => {
    if (e.target.classList.contains("pj-cantidad")) {
      subAdjustInputWidth(e.target);
    }
  });

  // Abrir lista items categoría, cargando esa categoría la primera vez que se abre
  selectListFromMenu(tabItems, "categ_selector", "carta-title", "#items-lists",
    (target, button) => loadSectionInto(
      document.getElementById(target.id + "-destroy"),
      "items_for_categ",
      button.dataset.categ_id));

  // Equipar/desquipar item (delegado)
  tabItems.addEventListener("click", e => {
    if (e.target.classList.contains("equipar")) {
      const button = e.target;
      const input = document.getElementById(button.dataset.input);
      const isEquipped = input.value !== "1";
      input.value = isEquipped ? "1" : "0";
      button.textContent = isEquipped ? "Equipado" : "Sin equipar";
      button.classList.toggle("btn-shadow", isEquipped);
    }
  });

  // Carga diferida de la pestaña (ítems propios + esqueleto por categoría)
  const tabItemsNav = document.querySelector('[data_tab_target="#tab-items"]');
  const tabItemsContent = document.getElementById("tab-items-content");
  tabItemsNav.addEventListener("click", () => {
    if (tabItemsContent.dataset.loaded === "1") return;
    tabItemsContent.dataset.loaded = "1";
    loadSectionInto(tabItemsContent, "items_tab");
  });


  // Añadir contador de clase/habilidad/ítem (delegado)
  form.addEventListener("click", e => {
    const button = e.target.closest(".add-contador");
    if (!button) return;
    const conts_body = document.getElementById(button.dataset.conts_body);
    const index = conts_body.querySelectorAll("tr").length;
    const prefix = button.dataset.prefix+"[calculados]["+index+"]";
    const template = document.getElementById("contador-template");
    const html = template.innerHTML.replace(/__PREFIX__/g, prefix);
    conts_body.insertAdjacentHTML("beforeend", html);
  });
}