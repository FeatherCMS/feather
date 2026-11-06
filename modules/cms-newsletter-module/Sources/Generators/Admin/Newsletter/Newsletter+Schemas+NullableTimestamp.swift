import FeatherOpenAPI

extension Newsletter.Schemas {
    struct NullableTimestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterNullableTimestampField" }
        var nullable: Bool? { true }
    }
}
