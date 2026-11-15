// Tiñe la barra del navegador móvil con el color base de la paleta
document.addEventListener("turbo:load", () => {
  let meta = document.querySelector('meta[name="theme-color"]')
  if (!meta) {
    meta = document.createElement("meta")
    meta.name = "theme-color"
    document.head.appendChild(meta)
  }
  const color = getComputedStyle(document.documentElement).getPropertyValue("--c_base").trim()
  meta.content = color
})
