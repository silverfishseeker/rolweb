function subAdjustInputWidth(input, modifier = 0) {
  input.style.maxWidth = `${(input.value.length || 1) + 2 + modifier}ch`;
}

export function adjustInputWidth(input, modifier = 0) {
  input.addEventListener("input", () => {
    subAdjustInputWidth(input, modifier);
  });
  subAdjustInputWidth(input, modifier);
}
