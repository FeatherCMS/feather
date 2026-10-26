import FeatherOpenAPI
import WebOpenAPIGeneratorSupport

extension Menu.Parameters {
    struct Key: PathParameterRepresentable {
        var openAPIIdentifier: String { "MenuKeyParameter" }
        var name: String { "key" }
        var description: String? { "Web menu key" }
        var schema: any OpenAPISchemaRepresentable {
            MenuKeyField().reference()
        }
    }
}
