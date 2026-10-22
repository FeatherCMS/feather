import FeatherOpenAPI

extension Settings.Parameters {
    struct UserID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUserIDParameter" }
        var name: String { "userId" }
        var schema: any OpenAPISchemaRepresentable {
            Settings.Fields.UserID().reference()
        }
    }
}
