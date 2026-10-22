import FeatherOpenAPI

extension Email.Parameters {
    struct ID: PathParameterRepresentable {
        var name: String { "authEmailId" }
        var description: String? { nil }
        var schema: any OpenAPISchemaRepresentable {
            Email.Schemas.IDField().reference()
        }
    }

    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update: identityId, email"
        }
        var schema: any OpenAPISchemaRepresentable {
            Email.Schemas.UpdateMask().reference()
        }
    }
}
