export function onTurboLoad() {
  const btn = document.querySelector("#random-generator-btn");
  const resultDiv = document.querySelector("#random-result");

  btn.addEventListener("click", () => {
    fetch("/get_random_element")
      .then(response => response.text())
      .then(html => {
        resultDiv.innerHTML = html;
      })
      .catch(err => {
        console.error("Error obteniendo elemento aleatorio:", err);
      });
  });
}
