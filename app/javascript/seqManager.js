// Descarta broadcasts obsoletos (llegados fuera de orden) para un id dado.
// seq viene de Date.now(), comparable entre pestañas.
const lastSeq = new Map(); // id -> seq más reciente visto

export function nextSeq(id) {
  const seq = Math.max(Date.now(), (lastSeq.get(id) || 0) + 1);
  lastSeq.set(id, seq);
  return seq;
}
window.nextSeq = nextSeq; // usado desde onclick= en las vistas

export function extractId(elementId) {
  return elementId.match(/-(\d+)(?:-|$)/)?.[1];
}

export function isFreshBroadcast(streamEl, key) {
  const seq = streamEl.getAttribute("seq");
  if (seq === null || seq === undefined || !key) return true;

  const current = lastSeq.get(key);
  const numSeq = Number(seq);
  if (current !== undefined && numSeq < current) return false;
  lastSeq.set(key, numSeq);
  return true;
}
