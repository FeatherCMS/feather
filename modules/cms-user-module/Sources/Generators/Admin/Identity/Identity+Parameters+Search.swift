import FeatherOpenAPI

extension Identity.Parameters {
    struct Search: QueryParameterRepresentable {
        var name: String { "search" }
        var required: Bool { false }
        var description: String? { "Search identity names" }
        var schema: any OpenAPISchemaRepresentable {
            Identity.Schemas.Search().reference()
        }
    }
}
