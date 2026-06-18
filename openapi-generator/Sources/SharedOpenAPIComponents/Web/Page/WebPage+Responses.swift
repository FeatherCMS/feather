import FeatherOpenAPI

public struct WebPageDetailResponse: JSONResponseRepresentable {
    public var description: String = "Web page detail"
    public var schema = WebPageDetailSchema().reference()

    public init() {}
}
