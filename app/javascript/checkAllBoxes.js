export function onTurboLoad() {
  const containers = document.querySelectorAll(".checks_container")
  containers.forEach( container => {
    const checkAll = container.querySelector(".check_all");
    const toggleables = container.querySelectorAll(".toggleable");
    checkAll.addEventListener("change", function() {
      toggleables.forEach(cb => cb.checked = checkAll.checked);
    });
  });
}