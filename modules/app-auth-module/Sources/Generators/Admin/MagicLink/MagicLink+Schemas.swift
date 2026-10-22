import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIdField" }
        var example: String? = "uml_k3P9qN2v"
    }
    struct CredentialID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkCredentialIdField" }
        var example: String? = "cred_k3P9qN2v"
    }
    struct Token: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkTokenField" }
        var example: String? = "mgl_3XbY..."
    }
    struct ExpiresAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkExpiresAtField" }
        var example: Double? { 1_760_000_000 }
    }
    struct IsUsed: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsUsedField" }
        var example: Bool? = false
    }
    struct IsPersistent: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkIsPersistentField" }
        var example: Bool? = true
    }
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateMaskField" }
        var example: String? = "credentialId,isPersistent"
    }
}
