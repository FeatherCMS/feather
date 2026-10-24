import FeatherOpenAPI

extension Profile.Fields {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileUserIDField" }
    }
}
