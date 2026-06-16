import { adjustInputWidth } from "./utils.js";

export function onTurboLoad() {
  document.querySelectorAll('input[type="number"]').forEach( input => {
    adjustInputWidth(input);
  });
}