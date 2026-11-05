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
}
