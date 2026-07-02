export function onTurboLoad() {
  const status = document.getElementById("download-status");

  document.querySelectorAll(".btn-download-backup").forEach(btn => {
    btn.addEventListener("click", () => {
      status.style.display = "block";
    });
  });
};