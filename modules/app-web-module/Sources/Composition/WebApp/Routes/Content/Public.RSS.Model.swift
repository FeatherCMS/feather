import WebModule

extension Public.RSS {
    struct Model: Sendable {
        let title: String
        let description: String
        let siteURL: String
        let items: [RSSItem]
    }
}
