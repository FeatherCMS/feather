struct AdminEditBlogSettingsModel: Sendable {
    let postListPath: String
    let authorListPath: String
    let tagListPath: String
    let postPathPrefix: String
    let authorPathPrefix: String
    let tagPathPrefix: String
    let hasMissingVariables: Bool
}
