// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"
import "./navbar.js"
import "./turboStreamActions.js"

Trix.config.blockAttributes.heading1.tagName = "h4"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("[data-js]").forEach(el => {
    const jsName = el.dataset.js
    import(`./${jsName}.js`)
      .then(module => module.onTurboLoad())
      .catch(err => console.error(`Error cargando ${jsName}.js`, err))
  })
})