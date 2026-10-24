import FeatherOpenAPI

extension MagicLink.Schemas {
    struct IsPersistent: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsPersistentField" }
        var example: Bool? = true
    }
}
