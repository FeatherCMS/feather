public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct MenuListResponse: JSONResponseRepresentable {
    public var description: String = "Web menu list"
    public var schema = MenuListSchema().reference()

    public init() {}
}

public struct MenuResponse: JSONResponseRepresentable {
    public var description: String = "Web menu"
    public var schema = MenuSchema().reference()

    public init() {}
}
