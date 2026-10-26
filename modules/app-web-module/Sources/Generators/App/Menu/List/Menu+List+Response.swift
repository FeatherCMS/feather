import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Menu.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MenuListResponse" }
        var description: String = "Web menu list"
        var schema: some SchemaRepresentable { MenuListSchema().reference() }
    }
}
