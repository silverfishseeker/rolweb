export function onTurboLoad() {
  const btn = document.getElementById("download-backup-btn");
  const status = document.getElementById("download-status");

  btn.addEventListener("click", () => {
    status.style.display = "block";
  });
};