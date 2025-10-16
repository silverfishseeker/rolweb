  document.addEventListener("turbo:load", () => {
    const ritualCheckbox = document.getElementById("ritual_checkbox");
    const ritualSection = document.getElementById("ritual_section");

    ritualCheckbox.addEventListener("change", () => {
      if (ritualCheckbox.checked) {
        ritualSection.style.display = "block";
      } else {
        ritualSection.style.display = "none";
      }
    });
  });