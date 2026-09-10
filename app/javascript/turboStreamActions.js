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
      this.targetElements.forEach(card => window.setItemCardState(card, false));
    } else {
      const container = document.getElementById(this.getAttribute("container"));
      container.appendChild(this.templateContent);
    }
  }
}

Turbo.StreamActions.remove_div = function () {
  const seqKey = this.getAttribute("seq_key");
  this.targetElements.forEach(el => {
    if (isFreshBroadcast(this, seqKey)) el.remove();
  });
}
