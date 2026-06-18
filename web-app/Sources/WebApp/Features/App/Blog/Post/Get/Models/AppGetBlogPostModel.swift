struct AppGetBlogPostModel: Sendable {
    let title: String
    let excerpt: String
    let imageURL: String?
    let content: String
    let publishedAt: String?
    let authors: [AppPublicAuthorSummaryModel]
    let tags: [AppPublicTagSummaryModel]
    let metadata: AppPublicMetadataModel
}
