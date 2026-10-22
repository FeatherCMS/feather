import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct CredentialID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkCredentialIdField" }
        var example: String? = "cred_k3P9qN2v"
    }
}
