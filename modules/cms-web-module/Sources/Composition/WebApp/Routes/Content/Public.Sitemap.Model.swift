import WebDomain
import WebModule

extension Public.Sitemap {
    struct Model: Sendable {
        let slugs: [String]
        let baseURL: String
        let trailingSlashBehavior: Settings.TrailingSlashBehavior
    }
}
