document.addEventListener("DOMContentLoaded", () => {
  const subnavbar = document.querySelector(".subnavbar");
  const scrollIndicator = document.querySelector(".subnavbar-scroll_indicator");

  function updateIndicatorVisibility() {
    const atEnd = subnavbar.scrollLeft + subnavbar.clientWidth >= subnavbar.scrollWidth - 1;
    scrollIndicator.style.display = atEnd ? "none" : "block";
  }

  function updateScrollIndicator() {
    if (subnavbar.scrollWidth > subnavbar.clientWidth) {
      scrollIndicator.style.display = "block";
      subnavbar.addEventListener("scroll", updateIndicatorVisibility);
    } else {
      scrollIndicator.style.display = "none";
      subnavbar.removeEventListener("scroll", updateIndicatorVisibility);
    }
  }


  function setupMobileSubmenus() {
    if (!( // Detect touch screen
        (window.PointerEvent && ('maxTouchPoints' in navigator)) ?
          navigator.maxTouchPoints > 0
        :
          ((window.matchMedia && window.matchMedia("(any-pointer:coarse)").matches) ||
          (window.TouchEvent || ('ontouchstart' in window)))
    ))
      return;

    const all_submenus = subnavbar.querySelectorAll(".submenu");
    const all_submenu_contents = subnavbar.querySelectorAll(".submenu-content");

    all_submenus.forEach(submenu => {
      const link = submenu.querySelector("a.nblink");

      if (link.classList.contains("nblink_notSubMenu")) return;

      let button = document.createElement("button");
      button.className = link.className;
      button.innerHTML = link.innerHTML;
      link.parentNode.replaceChild(button, link);

      const content = submenu.querySelector(".submenu-content");
      content.style.left = "0";

      button.addEventListener("click", (e) => {
        const isOpen = content.style.display === "block";
        all_submenu_contents.forEach(sc => sc.style.display = "none");
        subnavbar.querySelectorAll("button.nblink").forEach(btn => btn.classList.remove("open"));
        if (!isOpen) {
          content.style.display = "block";
          button.classList.add("open");
        }
      });
    });
  }


  // Initial setup
  updateScrollIndicator();
  setupMobileSubmenus();

  // Update on resize
  window.addEventListener("resize", updateScrollIndicator);
});
