export function onTurboLoad() {
  // Data modifiers
  document.querySelectorAll(".pjv-modifier").forEach( input => {
    input.addEventListener("input", () => {
      const base  = Number(document.getElementById(input.dataset.base).innerHTML);
      const value = document.getElementById(input.dataset.value);
      const mod = Number(input.value)
      const result =  base + mod;
      value.innerHTML = result;
      if ("mod" in input.dataset) {
        const mod = document.getElementById(input.dataset.mod);
        const new_mod = Math.floor(result / 2 - 5);
        if (new_mod > 0)
          mod.innerHTML ="+" + new_mod;
        else
        mod.innerHTML =new_mod;
      }
    });
  });
}