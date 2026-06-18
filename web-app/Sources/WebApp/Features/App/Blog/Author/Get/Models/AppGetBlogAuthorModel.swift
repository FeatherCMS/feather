struct AppGetBlogAuthorModel: Sendable {
    let title: String
    let subtitle: String
    let imageURL: String?
    let content: String
    let links: [AppPublicAuthorLinkModel]
    let posts: [AppPublicPostSummaryModel]
    let metadata: AppPublicMetadataModel
}
