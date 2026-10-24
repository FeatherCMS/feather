import FeatherOpenAPI

extension Contact.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "ContactTimestampField" }
    }
}
