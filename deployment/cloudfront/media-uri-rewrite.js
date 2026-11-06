// Keep these values aligned with STORAGE_OBJECT_KEY_DEPTH and
// STORAGE_OBJECT_KEY_SEGMENT_LENGTH on Server and Worker.
var OBJECT_KEY_DEPTH = 2;
var OBJECT_KEY_SEGMENT_LENGTH = 2;

function validPrefix(parts) {
    if (parts.length !== OBJECT_KEY_DEPTH + 1) return false;
    for (var i = 0; i < OBJECT_KEY_DEPTH; i += 1) {
        if (!/^[A-Za-z0-9_-]+$/.test(parts[i])) return false;
        if (parts[i].length !== OBJECT_KEY_SEGMENT_LENGTH) return false;
    }
    if (!/^[A-Za-z0-9_-]+$/.test(parts[OBJECT_KEY_DEPTH])) return false;
    return parts[OBJECT_KEY_DEPTH].length > 0;
}

function handler(event) {
    var request = event.request;
    var parts = request.uri.split("/");
    if (parts[0] !== "") return request;
    parts.shift();

    // All media objects live under the bucket's top-level public namespace.
    if (parts[0] !== "public") return request;
    parts.shift();

    var markerIndex = OBJECT_KEY_DEPTH + 1;
    var prefixParts = parts.slice(0, markerIndex);
    if (parts.length <= markerIndex || !validPrefix(prefixParts)) {
        // The app leaves unusually short IDs unsplit rather than creating
        // empty shard segments. Resolve that explicit storage fallback too.
        if (
            OBJECT_KEY_DEPTH > 0 &&
            parts.length > 2 &&
            /^[A-Za-z0-9_-]+$/.test(parts[0]) &&
            (parts[1] === "originals" || parts[1] === "variants")
        ) {
            markerIndex = 1;
            prefixParts = parts.slice(0, markerIndex);
        } else {
            return request;
        }
    }
    var prefix = prefixParts.join("/");
    var marker = parts[markerIndex];

    if (marker === "originals") {
        var originalPath = parts.slice(markerIndex + 1);
        if (originalPath.length === 0) return request;
        var originalName = originalPath[originalPath.length - 1];
        var originalMatch = originalName.match(/\.([A-Za-z0-9]+)$/);
        if (!originalMatch) return request;
        request.uri = "/public/" + prefix + "/original." + originalMatch[1].toLowerCase();
        return request;
    }

    if (marker === "variants") {
        if (parts.length <= markerIndex + 2) return request;
        var variantKey = parts[markerIndex + 1];
        if (!/^[A-Za-z0-9_-]+$/.test(variantKey)) return request;
        var variantPath = parts.slice(markerIndex + 2);
        var variantName = variantPath[variantPath.length - 1];
        var variantMatch = variantName && variantName.match(/\.([A-Za-z0-9]+)$/);
        if (!variantMatch) return request;
        request.uri = "/public/" + prefix + "/variants/" + variantKey + "." + variantMatch[1].toLowerCase();
    }

    return request;
}
