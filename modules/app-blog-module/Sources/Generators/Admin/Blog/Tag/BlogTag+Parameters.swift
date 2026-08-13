import FeatherOpenAPI

struct BlogTagIdParameter: PathParameterRepresentable {
    var name: String { "blogTagId" }
    var description: String? { "BlogTag id" }
    var schema: any OpenAPISchemaRepresentable {
        BlogTagIdField().reference()
    }
}
