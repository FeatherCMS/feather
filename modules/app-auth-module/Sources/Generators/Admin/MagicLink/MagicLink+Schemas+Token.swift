import FeatherOpenAPI

extension MagicLink.Schemas {
    struct Token: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkTokenField" }
        var example: String? = "mgl_3XbY..."
    }
}
