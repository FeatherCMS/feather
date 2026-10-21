import FeatherOpenAPI

struct RedirectRuleIdParameter: PathParameterRepresentable {
    var name: String { "redirectRuleId" }
    var description: String? { "RedirectRule id" }
    var schema: any OpenAPISchemaRepresentable {
        RedirectRuleIdField().reference()
    }
}

struct RedirectRuleUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? {
        "Comma-separated list of fields to update. Include notes to clear it when omitted from the request body."
    }
    var schema: any OpenAPISchemaRepresentable {
        RedirectRuleUpdateMaskField().reference()
    }
}
