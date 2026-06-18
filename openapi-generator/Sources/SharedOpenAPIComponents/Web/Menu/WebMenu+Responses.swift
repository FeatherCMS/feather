import FeatherOpenAPI

public struct WebMenuListResponse: JSONResponseRepresentable {
    public var description: String = "Web menu list"
    public var schema = WebMenuListSchema().reference()

    public init() {}
}
