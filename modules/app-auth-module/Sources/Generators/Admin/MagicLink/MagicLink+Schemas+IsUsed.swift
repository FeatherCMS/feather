import FeatherOpenAPI

extension MagicLink.Schemas {
    struct IsUsed: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsUsedField" }
        var example: Bool? = false
    }
}
