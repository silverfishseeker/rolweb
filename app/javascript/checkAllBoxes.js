document.addEventListener("DOMContentLoaded", function() {
  const checkAll = document.getElementById("check_all");
  const toggleables = document.querySelectorAll(".toggleable");

  checkAll.addEventListener("change", function() {
    toggleables.forEach(cb => cb.checked = checkAll.checked);
  });
});