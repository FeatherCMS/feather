import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkUpdateMaskField" }
        var example: String? = "credentialId,isPersistent"
    }
}
