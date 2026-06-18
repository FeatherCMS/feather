import FeatherOpenAPI

public struct BlogAuthorListResponse: JSONResponseRepresentable {
    public var description: String = "Blog author list"
    public var schema = BlogAuthorListSchema().reference()

    public init() {}
}

public struct BlogAuthorDetailResponse: JSONResponseRepresentable {
    public var description: String = "Blog author detail"
    public var schema = BlogAuthorDetailSchema().reference()

    public init() {}
}
