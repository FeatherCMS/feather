import FeatherOpenAPI

extension Invitation.Schemas {
    struct ExpiresAt: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }
    }
}
