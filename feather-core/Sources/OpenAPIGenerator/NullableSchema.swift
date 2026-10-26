public import FeatherOpenAPI

public extension StringSchemaRepresentable {
    func nullable() -> some StringSchemaRepresentable {
        NullableSchema(base: self)
    }
}

private struct NullableSchema<Base: StringSchemaRepresentable>:
    StringSchemaRepresentable
{
    let base: Base

    var openAPIIdentifier: String { "\(base.openAPIIdentifier)Nullable" }
    var required: Bool { base.required }
    var title: String? { base.title }
    var description: String? { base.description }
    var nullable: Bool? { true }
    var deprecated: Bool? { base.deprecated }
    var example: String? { base.example }
    var defaultValue: String? { base.defaultValue }
    var allowedValues: [String]? { base.allowedValues }
}
