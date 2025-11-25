export function onTurboLoad() {
    document.querySelectorAll(".etiqueta-item").forEach(item => {
        item.addEventListener("click", () => {
            const checkbox = item.querySelector("input");
            checkbox.checked = !checkbox.checked;
            item.classList.toggle("active", checkbox.checked);
        });
    });
}