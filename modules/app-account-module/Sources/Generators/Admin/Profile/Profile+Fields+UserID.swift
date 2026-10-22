import FeatherOpenAPI
import OpenAPIKit30

extension Profile.Fields {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileUserIDField" }
    }
}
