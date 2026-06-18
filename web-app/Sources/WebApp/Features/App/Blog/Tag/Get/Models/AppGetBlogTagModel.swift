struct AppGetBlogTagModel: Sendable {
    let title: String
    let excerpt: String
    let imageURL: String?
    let content: String
    let posts: [AppPublicPostSummaryModel]
    let metadata: AppPublicMetadataModel
}
