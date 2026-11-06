import FeatherOpenAPI

extension Identity.Parameters {
    struct RoleFilter: QueryParameterRepresentable {
        var name: String { "role" }
        var required: Bool { false }
        var description: String? { "Filter identities by role name" }
        var schema: any OpenAPISchemaRepresentable {
            Role.Schemas.Name().reference()
        }
    }
}
