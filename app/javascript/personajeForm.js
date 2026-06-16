import { nextZIndex } from "./zIndexCounter.js";
import { adjustInputWidth } from "./utils.js";
import { createCloseModalHandler  }  from "./modals.js";
import { initTabs } from "./tabs.js";

export function onTurboLoad() {

  //tabs
  initTabs(document.querySelector('.pj-form'));  

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
  document.addEventListener("change", e => {
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
        copy_to.dispatchEvent( new Event("input", { bubbles: true }));
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


  // CLASES Y HABILIDADES
  const clasesContainer = document.getElementById("clases-section");
  const habilidadesContainer = document.getElementById("habilidades-section");

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

  // Mover clase
  const aliveClasesContainer = document.getElementById("clases_container_0");
  const destroyClasesContainer = document.getElementById("clases_container_1");
  clasesContainer.querySelectorAll(".carta-add_buttom").forEach(button => {
    button.addEventListener("click", () => {
      moveCarta(button, aliveClasesContainer, destroyClasesContainer);
    });
  });

  // Mover habilidad
  habilidadesContainer.querySelectorAll(".carta-add_buttom").forEach(button => {
    button.addEventListener("click", () => {
      const aliveContainer = document.getElementById(button.dataset.alive_container);
      const destroyContainer = document.getElementById(button.dataset.destroy_container);
      moveCarta(button, aliveContainer, destroyContainer);
    });
  });

  // Modal sobreescritura clase y habilidad
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
  modalHandelers(clasesContainer);
  modalHandelers(habilidadesContainer);

  // Reseteo clase de habilidad
  habilidadesContainer.addEventListener("click", e => {
    if (e.target.classList.contains("boton_reseteo_clase")) {
      const select = document.getElementById(e.target.dataset.id_select);
      select.value = e.target.dataset.id_clase;
    }
  });

  // Abrir lista genérica
  function selectListFromMenu(containerMenu, containerLists, menuClass) {
    containerMenu.querySelectorAll(`.${menuClass}`).forEach(button => {
      button.addEventListener("click", () => {
        containerLists.querySelectorAll(".pj-selected_list").forEach(l => {
          l.classList.remove("pj-selected_list-active");
        });
        containerMenu.querySelectorAll(`.${menuClass}`).forEach(button => {
          button.classList.remove(`${menuClass}-selected`);
        });
        document.getElementById(button.dataset.list).classList.add("pj-selected_list-active");
        button.classList.add(`${menuClass}-selected`);
      });
    });
  }

  // Abrir lista habilidades clase
  selectListFromMenu(clasesContainer, habilidadesContainer, "carta_form_clase");

  // Añadir contador de clase/habilidad/ítem
  document.querySelectorAll(".add-contador").forEach(button => {
    button.addEventListener("click", () => {
      const conts_body = document.getElementById(button.dataset.conts_body);
      const index = conts_body.querySelectorAll("tr").length;
      const prefix = button.dataset.prefix+"[calculados]["+index+"]";
      const template = document.getElementById("contador-template");
      const html = template.innerHTML.replace(/__PREFIX__/g, prefix);
      conts_body.insertAdjacentHTML("beforeend", html);
    });
  });

  // Toggle rango contador clase/habilidad
  function addToggleRangoListener(container) {
    container.addEventListener("click", e => {
      if (e.target.classList.contains("toggle-rango")) {
        toggleRango(e.target);
      }
    });
  }
  addToggleRangoListener(clasesContainer);
  addToggleRangoListener(habilidadesContainer);



  // ITEMS

  const itemsContainer = document.getElementById("tab-items");
  // Modal sobreescritura
  modalHandelers(itemsContainer);

  // Abrir lista items categoría
  const menu = document.getElementById("items-menu");
  const listsContainer = document.getElementById("items-lists");
  selectListFromMenu(menu, listsContainer, "carta-title");

  // Mover item
  itemsContainer.querySelectorAll(".carta-add_buttom").forEach(button => {
    button.addEventListener("click", () => {
      const aliveContainer = document.getElementById("items-list-alive");
      const destroyContainer = document.getElementById(button.dataset.destroy_container);
      moveCarta(button, aliveContainer, destroyContainer);
    });
  });

  // Ajustar ancho input cantidad
  itemsContainer.querySelectorAll(".pj-cantidad").forEach(input => {
    adjustInputWidth(input);
  });
}