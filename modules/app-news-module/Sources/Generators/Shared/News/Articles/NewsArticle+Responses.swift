import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsArticleListResponse: JSONResponseRepresentable {
    public var description: String = "News item list"
    public var schema = NewsArticleListSchema().reference()

    public init() {}
}

public struct NewsArticleDetailResponse: JSONResponseRepresentable {
    public var description: String = "News item detail"
    public var schema = NewsArticleDetailSchema().reference()

    public init() {}
}
