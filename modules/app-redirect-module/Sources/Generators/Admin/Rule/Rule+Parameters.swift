import FeatherOpenAPI

extension Rule.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "RedirectRuleIdParameter" }
        var name: String { "redirectRuleId" }
        var description: String? { "RedirectRule id" }
        var schema: any OpenAPISchemaRepresentable {
            Rule.Schemas.ID().reference()
        }
    }

    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "RedirectRuleUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include notes to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            Rule.Schemas.UpdateMask().reference()
        }
    }
}
