import FeatherOpenAPI

struct RedirectRuleIdParameter: PathParameterRepresentable {
    var name: String { "redirectRuleId" }
    var description: String? { "RedirectRule id" }
    var schema: any OpenAPISchemaRepresentable {
        RedirectRuleIdField().reference()
    }
}
