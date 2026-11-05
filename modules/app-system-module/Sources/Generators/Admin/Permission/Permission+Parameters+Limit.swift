import FeatherOpenAPI

extension Permission.Parameters {
    struct Limit: QueryParameterRepresentable {
        var name: String { "limit" }
        var required: Bool { false }
        var description: String? {
            "Defaults to 20; values are clamped to 1-100"
        }
        var schema: any OpenAPISchemaRepresentable {
            Permission.Schemas.Limit().reference()
        }
    }
}
