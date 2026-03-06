const rawBasePath = (import.meta.env.BASE_URL || "/").trim();

const normalizedBasePath = (() => {
  if (rawBasePath === "" || rawBasePath === "/") return "/";
  return `/${rawBasePath.replace(/^\/+|\/+$/g, "")}/`;
})();

const normalizedBasePathNoSlash =
  normalizedBasePath === "/" ? "" : normalizedBasePath.replace(/\/$/, "");

export function getBasePath(): string {
  return normalizedBasePath;
}

export function withBasePath(path: string): string {
  if (!path) return getBasePath();

  if (
    path.startsWith("http://") ||
    path.startsWith("https://") ||
    path.startsWith("mailto:") ||
    path.startsWith("tel:") ||
    path.startsWith("#") ||
    path.startsWith("data:")
  ) {
    return path;
  }

  if (normalizedBasePath === "/") return path;

  if (path.startsWith(normalizedBasePath)) return path;
  if (path.startsWith(normalizedBasePathNoSlash + "/")) return path;

  if (path.startsWith("/")) {
    return normalizedBasePathNoSlash + path;
  }

  return path;
}

export function stripBasePath(pathname: string): string {
  if (normalizedBasePath === "/") return pathname || "/";

  if (pathname === normalizedBasePathNoSlash) return "/";
  if (pathname.startsWith(normalizedBasePathNoSlash + "/")) {
    const stripped = pathname.slice(normalizedBasePathNoSlash.length);
    return stripped === "" ? "/" : stripped;
  }
  return pathname || "/";
}
