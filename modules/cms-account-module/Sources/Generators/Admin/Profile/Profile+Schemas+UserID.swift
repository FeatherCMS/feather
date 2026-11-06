import FeatherOpenAPI

extension Profile.Schemas {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileUserIDField" }
    }
}
