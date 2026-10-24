import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct IsPersistent: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsPersistentField" }
        var example: Bool? = true
    }
}
