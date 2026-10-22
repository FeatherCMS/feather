import WebModule

struct AppPublicRSSModel: Sendable {
    let title: String
    let description: String
    let siteURL: String
    let items: [RSSItem]
}
