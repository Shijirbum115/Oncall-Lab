const mnt = new Intl.NumberFormat("mn-MN", { maximumFractionDigits: 0 });

export function formatMnt(amount: number | null | undefined) {
  if (amount == null) return "—";
  return `₮${mnt.format(amount)}`;
}

export function formatDate(value: string | null | undefined) {
  if (!value) return "—";
  return new Date(value).toLocaleDateString("en-GB", {
    day: "2-digit",
    month: "short",
    year: "numeric",
  });
}

export function formatDateTime(value: string | null | undefined) {
  if (!value) return "—";
  return new Date(value).toLocaleString("en-GB", {
    day: "2-digit",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  });
}

/** Same scheme the Flutter app uses: 99123456 -> 99123456@bugamed.dev */
export function phoneToEmail(phone: string) {
  let sanitized = phone.replaceAll(" ", "");
  if (sanitized.startsWith("+976")) sanitized = sanitized.slice(4);
  return `${sanitized}@bugamed.dev`;
}

export function initials(name: string | null | undefined) {
  if (!name) return "?";
  return name
    .split(" ")
    .map((p) => p[0])
    .slice(0, 2)
    .join("")
    .toUpperCase();
}
