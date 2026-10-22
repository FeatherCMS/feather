import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct IsUsed: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsUsedField" }
        var example: Bool? = false
    }
}
