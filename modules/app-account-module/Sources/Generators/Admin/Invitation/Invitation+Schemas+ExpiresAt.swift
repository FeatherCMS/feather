import FeatherOpenAPI
import OpenAPIKit30

extension Invitation.Schemas {
    struct ExpiresAt: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }
    }
}
