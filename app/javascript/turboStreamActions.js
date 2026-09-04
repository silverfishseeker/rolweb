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