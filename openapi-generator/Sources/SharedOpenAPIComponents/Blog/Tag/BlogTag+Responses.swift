import FeatherOpenAPI

public struct BlogTagListResponse: JSONResponseRepresentable {
    public var description: String = "Blog tag list"
    public var schema = BlogTagListSchema().reference()

    public init() {}
}

public struct BlogTagDetailResponse: JSONResponseRepresentable {
    public var description: String = "Blog tag detail"
    public var schema = BlogTagDetailSchema().reference()

    public init() {}
}
