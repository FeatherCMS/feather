import FeatherOpenAPI

extension Newsletter.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterTimestampField" }
    }
}
