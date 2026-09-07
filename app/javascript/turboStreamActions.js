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
  const seq = this.getAttribute("seq");
  const value = this.getAttribute("value") === "true";
  this.targetElements.forEach(el => {
    if (seq !== null) {
      const phiId = el.id.match(/-(\d+)-/)?.[1];
      if (phiId && window.isStaleItemSeq(phiId, seq)) return; // ya hay una acción más reciente sobre este ítem
    }
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
  const seq = this.getAttribute("seq");
  this.targetElements.forEach(card => {
    const phiId = card.id.match(/-(\d+)$/)[1];
    if (window.isStaleItemSeq(phiId, seq)) return; // ya hay una acción más reciente sobre este ítem
    if (!card.classList.contains("pj-fila_borrada"))
      card.remove();
  });
}

Turbo.StreamActions.upsert_item = function () {
  const seq = this.getAttribute("seq");
  const phiId = this.getAttribute("target").match(/-(\d+)$/)[1];
  if (window.isStaleItemSeq(phiId, seq)) return; // ya hay una acción más reciente sobre este ítem

  if (this.targetElements.length > 0) {
    this.targetElements.forEach(card => window.setItemCardState(card, false));
  } else {
    const container = document.getElementById(this.getAttribute("container"));
    container.appendChild(this.templateContent);
  }
}

Turbo.StreamActions.remove_div = function () {
  const seq = this.getAttribute("seq");
  this.targetElements.forEach(el => {
    if (seq !== null) {
      const phiId = el.id.match(/-(\d+)$/)?.[1];
      if (phiId && window.isStaleItemSeq(phiId, seq)) return; // ya hay una acción más reciente sobre este ítem
    }
    el.remove();
  });
}