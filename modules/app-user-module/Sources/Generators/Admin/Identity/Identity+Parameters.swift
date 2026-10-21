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

    struct RoleFilter: QueryParameterRepresentable {
        var name: String { "role" }
        var required: Bool { false }
        var description: String? { "Filter identities by role name" }
        var schema: any OpenAPISchemaRepresentable {
            Role.Schemas.Name().reference()
        }
    }

    struct ListLimit: QueryParameterRepresentable {
        var name: String { "limit" }
        var required: Bool { false }
        var description: String? {
            "Defaults to 20; values are clamped to 1-100"
        }
        var schema: any OpenAPISchemaRepresentable {
            Identity.Schemas.ListLimit().reference()
        }
    }

    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            Identity.Schemas.UpdateMask().reference()
        }
    }
}

extension Identity.Schemas {
    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentitySearch" }
        var example: String? = "Ada"
    }

    struct ListLimit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityListLimit" }
        var description: String? {
            "Maximum number of identities. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 100
    }

    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityUpdateMask" }
        var example: String? = "name,status,roleIds"
    }
}
