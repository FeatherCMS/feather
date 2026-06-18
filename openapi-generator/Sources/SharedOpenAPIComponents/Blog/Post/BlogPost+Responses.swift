import FeatherOpenAPI

public struct BlogPostListResponse: JSONResponseRepresentable {
    public var description: String = "Blog post list"
    public var schema = BlogPostListSchema().reference()

    public init() {}
}

public struct BlogPostDetailResponse: JSONResponseRepresentable {
    public var description: String = "Blog post detail"
    public var schema = BlogPostDetailSchema().reference()

    public init() {}
}
