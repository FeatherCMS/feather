import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Menu.Key.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MenuResponse" }
        var description: String = "Web menu"
        var schema: some SchemaRepresentable { MenuSchema().reference() }
    }
}
