import Application

public struct PublicBlogRouteSettings: DTO {
    public let postListPath: String
    public let authorListPath: String
    public let tagListPath: String
    public let postPathPrefix: String
    public let authorPathPrefix: String
    public let tagPathPrefix: String
    public let siteNoIndex: Bool

    public init(
        postListPath: String,
        authorListPath: String,
        tagListPath: String,
        postPathPrefix: String,
        authorPathPrefix: String,
        tagPathPrefix: String,
        siteNoIndex: Bool
    ) {
        self.postListPath = postListPath
        self.authorListPath = authorListPath
        self.tagListPath = tagListPath
        self.postPathPrefix = postPathPrefix
        self.authorPathPrefix = authorPathPrefix
        self.tagPathPrefix = tagPathPrefix
        self.siteNoIndex = siteNoIndex
    }
}
