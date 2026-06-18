struct AppGetWebPageModel: Sendable {
    let title: String
    let excerpt: String
    let imageURL: String?
    let content: String
    let metadata: AppPublicMetadataModel
}
