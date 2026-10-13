enum MediaAssetNodeSlugPath {
    static let sql =
        "CASE WHEN n.absolute_slug = '' THEN n.slug ELSE n.absolute_slug || '/' || n.slug END"

    static func parent(of slugPath: String) -> String {
        String(slugPath.split(separator: "/").dropLast().joined(separator: "/"))
    }

    static func slug(of slugPath: String) -> String {
        String(slugPath.split(separator: "/").last ?? "")
    }
}
