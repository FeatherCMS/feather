import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct NewsCategoryListResponse: JSONResponseRepresentable {
    public var description: String = "News category list"
    public var schema = NewsCategoryListSchema().reference()

    public init() {}
}

public struct NewsCategoryDetailResponse: JSONResponseRepresentable {
    public var description: String = "News category detail"
    public var schema = NewsCategoryDetailSchema().reference()

    public init() {}
}
