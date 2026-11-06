import FeatherOpenAPI

extension Identity.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "UserIdentityIdParameter" }
        var name: String { "userIdentityId" }
        var description: String? { "User identity id" }
        var schema: any OpenAPISchemaRepresentable {
            Identity.Schemas.ID().reference()
        }
    }
}
