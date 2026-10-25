import FeatherOpenAPI

extension Profile.Parameters {
    struct UserID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AccountProfileUserIDParameter" }
        var name: String { "userId" }
        var schema: any OpenAPISchemaRepresentable {
            Profile.Schemas.UserID().reference()
        }
    }
}
