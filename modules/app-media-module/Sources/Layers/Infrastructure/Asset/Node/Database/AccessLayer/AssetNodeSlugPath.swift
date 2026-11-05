import FeatherDomain
import MediaModule

extension Asset.Node.SlugPath {
    static let sql =
        "CASE WHEN n.absolute_slug = '' THEN n.slug ELSE n.absolute_slug || '/' || n.slug END"

    static func parent(of slugPath: String) -> String {
        Slug(parsing: slugPath).parent?.path ?? ""
    }

    static func slug(of slugPath: String) -> String {
        Slug(parsing: slugPath).lastSegment?.value ?? ""
    }
}
