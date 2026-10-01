import WebContracts

struct AppPublicRSSModel: Sendable {
    let title: String
    let description: String
    let siteURL: String
    let items: [WebRSSItem]
}
