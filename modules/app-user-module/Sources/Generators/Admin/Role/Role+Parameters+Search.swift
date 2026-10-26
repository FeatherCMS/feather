import FeatherOpenAPI

extension Role.Parameters {
    struct Search: QueryParameterRepresentable {
        var name: String { "search" }
        var required: Bool { false }
        var description: String? { "Search role keys, names, and notes" }
        var schema: any OpenAPISchemaRepresentable {
            Role.Schemas.Search().reference()
        }
    }
}
