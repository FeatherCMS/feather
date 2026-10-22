import FeatherOpenAPI
import OpenAPIKit30

extension MagicLink.Schemas {
    struct ExpiresAt: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AuthMagicLinkExpiresAtField" }
        var example: Double? { 1_760_000_000 }
    }
}
