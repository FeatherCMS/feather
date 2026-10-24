import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

struct MenuKeyParameter: PathParameterRepresentable {
    var name: String { "key" }
    var description: String? { "Web menu key" }
    var schema: any OpenAPISchemaRepresentable {
        MenuKeyField().reference()
    }

    init() {}
}
