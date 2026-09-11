import { isFreshBroadcast } from "./seqManager.js";

const TYPING_GRACE_MS = 1500;

Turbo.StreamActions.update_div = function () {
  const value = this.getAttribute("value");
  const seqKey = this.getAttribute("seq_key");
  this.targetElements.forEach(div => {
    if (!isFreshBroadcast(this, seqKey)) return;
    if (div.tagName === "INPUT" || div.tagName === "TEXTAREA" || div.tagName === "SELECT") {
      if (!(document.activeElement === div && // no interrumpir mientras se está escribiendo ahí
          Date.now() - (div.dataset.lastInput || 0) < TYPING_GRACE_MS))
        div.value = value;
    } else {
      div.textContent = value;
    }
  });
}

Turbo.StreamActions.update_rich_text = function () {
  const value = this.getAttribute("value");
  this.targetElements.forEach(editor => {
    editor.value = value; // también actualiza defaultValue, para no confundir esto con una edición real
    editor.dataset.dirty = "0";
    const saveButton = editor.toolbarElement.querySelector(".pjv-trix-save_btn");
    if (saveButton) saveButton.disabled = true;
  });
}

Turbo.StreamActions.set_hidden = function () {
  const value = this.getAttribute("value") === "true";
  const seqKey = this.getAttribute("seq_key");
  this.targetElements.forEach(el => {
    if (isFreshBroadcast(this, seqKey))
      el.hidden = el.id.endsWith("-desequipar") ? !value : value;
  });
}

Turbo.StreamActions.toggle_class = function () {
  const div = this.targetElements[0];
  const className = this.getAttribute("class-name");
  const on = this.getAttribute("on") === "true";
  div.classList.toggle(className, on);
}

Turbo.StreamActions.eliminar_item = function () {
  const seqKey = this.getAttribute("seq_key");
  this.targetElements.forEach(card => {
    if (isFreshBroadcast(this, seqKey) && !card.classList.contains("pj-fila_borrada"))
      card.remove();
  });
}

Turbo.StreamActions.upsert_item = function () {
  if (isFreshBroadcast(this, this.getAttribute("seq_key"))) {
    if (this.targetElements.length > 0) {
      const fresh = this.templateContent.firstElementChild;
      this.targetElements.forEach(card => {
        card.dataset.ordenadoId = fresh.dataset.ordenadoId;
        card.dataset.position = fresh.dataset.position;
        window.setItemCardState(card, false);
      });
    } else {
      const container = document.getElementById(this.getAttribute("container"));
      const before = document.getElementById(this.getAttribute("before"));
      const fragment = this.templateContent;
      const posController = fragment.querySelector(".pjv-pos_controller"); // antes de insertar: el fragmento se vacía al insertarse
      if (before) container.insertBefore(fragment, before);
      else container.appendChild(fragment);
      window.bindPositionController(posController);
    }
  }
}

Turbo.StreamActions.remove_div = function () {
  const seqKey = this.getAttribute("seq_key");
  this.targetElements.forEach(el => {
    if (isFreshBroadcast(this, seqKey)) el.remove();
  });
}

// Idempotente a propósito (mover algo justo antes de otro elemento no cambia nada si
// ya está ahí), así no hace falta protegerlo con seq: da igual aplicarlo más de una vez.
Turbo.StreamActions.move_before = function () {
  const moved = document.getElementById(this.getAttribute("moved"));
  const before = document.getElementById(this.getAttribute("before"));
  if (moved && before) {
    before.parentNode.insertBefore(moved, before);
    moved.dataset.position = this.getAttribute("moved_position");
    before.dataset.position = this.getAttribute("before_position");
  }
}
