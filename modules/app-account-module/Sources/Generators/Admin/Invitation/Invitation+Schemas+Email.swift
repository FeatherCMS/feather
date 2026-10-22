import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Schemas {
    struct Email: StringSchemaRepresentable {
        var example: String? = "john.doe@example.com"
    }
}
