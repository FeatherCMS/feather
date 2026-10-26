import FeatherOpenAPI

extension MagicLink.Schemas {
    struct CredentialID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkCredentialIdField" }
        var example: String? = "cred_k3P9qN2v"
    }
}
