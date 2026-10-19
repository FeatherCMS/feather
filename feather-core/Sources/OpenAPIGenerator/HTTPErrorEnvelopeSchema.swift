public import FeatherOpenAPI
public import OpenAPIKit30

public struct HTTPErrorEnvelopeSchema<Content: SchemaRepresentable>:
    ObjectSchemaRepresentable
{
    private let error: Content

    public init(error: Content) {
        self.error = error
    }

    public var openAPIIdentifier: String {
        "\(error.openAPIIdentifier)HTTPErrorEnvelopeSchema"
    }

    public var propertyMap: SchemaMap {
        [
            "error": error.reference(),
            "trace": ErrorTraceSchema().reference(required: false),
        ]
    }
}
