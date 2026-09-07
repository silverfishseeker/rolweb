import { isFreshBroadcast } from "./seqManager.js";

Turbo.StreamActions.update_div = function () {
  const value = this.getAttribute("value");
  this.targetElements.forEach(div => {
    if (div.tagName === "INPUT" || div.tagName === "TEXTAREA" || div.tagName === "SELECT") {
      if (document.activeElement === div) return; // no interrumpir mientras se está escribiendo ahí
      div.value = value;
    } else {
      div.textContent = value;
    }
  });
}

Turbo.StreamActions.set_hidden = function () {
  const value = this.getAttribute("value") === "true";
  this.targetElements.forEach(el => {
    if (isFreshBroadcast(this, el.id))
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
  this.targetElements.forEach(card => {
    if (isFreshBroadcast(this, card.id) && !card.classList.contains("pj-fila_borrada"))
      card.remove();
  });
}

Turbo.StreamActions.upsert_item = function () {
  if (isFreshBroadcast(this, this.getAttribute("target"))) {
    if (this.targetElements.length > 0) {
      this.targetElements.forEach(card => window.setItemCardState(card, false));
    } else {
      const container = document.getElementById(this.getAttribute("container"));
      container.appendChild(this.templateContent);
    }
  }
}

Turbo.StreamActions.remove_div = function () {
  this.targetElements.forEach(el => {
    if (isFreshBroadcast(this, el.id)) el.remove();
  });
}