Turbo.StreamActions.update_div = function () {
  const div = this.targetElements[0];
  if (document.activeElement === div) return; // no interrumpir mientras se está escribiendo ahí
  const value = this.getAttribute("value");

  if (div.tagName === "INPUT" || div.tagName === "TEXTAREA" || div.tagName === "SELECT") {
    div.value = value;
  } else {
    div.textContent = value;
  }
}

Turbo.StreamActions.toggle_class = function () {
  const div = this.targetElements[0];
  const className = this.getAttribute("class-name");
  const on = this.getAttribute("on") === "true";
  div.classList.toggle(className, on);
}