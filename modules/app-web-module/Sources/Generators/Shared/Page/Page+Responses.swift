public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct PageDetailResponse: JSONResponseRepresentable {
    public var description: String = "Web page detail"
    public var schema = PageDetailSchema().reference()

    public init() {}
}
