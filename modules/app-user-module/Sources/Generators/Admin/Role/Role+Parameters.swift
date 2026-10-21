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

    struct ListLimit: QueryParameterRepresentable {
        var name: String { "limit" }
        var required: Bool { false }
        var description: String? {
            "Defaults to 20; values are clamped to 1-100"
        }
        var schema: any OpenAPISchemaRepresentable {
            Role.Schemas.ListLimit().reference()
        }
    }

    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            Role.Schemas.UpdateMask().reference()
        }
    }
}

extension Role.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserRoleUpdateMask" }
        var example: String? = "name,notes"
    }
}
