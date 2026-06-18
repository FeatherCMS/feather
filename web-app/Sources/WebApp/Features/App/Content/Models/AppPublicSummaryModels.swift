struct AppPublicPostSummaryModel: Sendable {
    let title: String
    let excerpt: String
    let href: String
    let publishedAt: String?
    let metadata: AppPublicMetadataModel
}

struct AppPublicAuthorSummaryModel: Sendable {
    let name: String
    let excerpt: String
    let href: String
    let imageURL: String?
    let metadata: AppPublicMetadataModel
}

struct AppPublicTagSummaryModel: Sendable {
    let title: String
    let excerpt: String
    let href: String
    let metadata: AppPublicMetadataModel
}

struct AppPublicAuthorLinkModel: Sendable {
    let label: String
    let url: String
    let isBlank: Bool
}
