import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIdField" }
        var example: String? = "uml_k3P9qN2v"
    }
}
