export function onTurboLoad() {
  const input = document.getElementById("buscador-input");
  
  input.addEventListener("input", () => {
    const query = input.value.toLowerCase().trim();

    document.querySelectorAll(".grid-container").forEach(grid => {
      grid.querySelectorAll(".carta").forEach(carta => {
        const texto = carta.innerText.toLowerCase();
        carta.style.display = texto.includes(query) ? "flex" : "none";
      });
    });

    document.querySelectorAll(".categ").forEach(categ => {
      const cartasVisibles = categ.querySelectorAll(".carta:not([style*='display: none'])");
      categ.style.display = cartasVisibles.length > 0 ? "block" : "none";
    });
  });
}
