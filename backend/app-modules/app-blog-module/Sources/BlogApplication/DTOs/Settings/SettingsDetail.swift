import Application

public struct SettingsDetail: DTO {
    public let id: String
    public let postListPath: String
    public let authorListPath: String
    public let tagListPath: String
    public let postPathPrefix: String
    public let authorPathPrefix: String
    public let tagPathPrefix: String

    package init(
        id: String,
        postListPath: String,
        authorListPath: String,
        tagListPath: String,
        postPathPrefix: String,
        authorPathPrefix: String,
        tagPathPrefix: String
    ) {
        self.id = id
        self.postListPath = postListPath
        self.authorListPath = authorListPath
        self.tagListPath = tagListPath
        self.postPathPrefix = postPathPrefix
        self.authorPathPrefix = authorPathPrefix
        self.tagPathPrefix = tagPathPrefix
    }
}
