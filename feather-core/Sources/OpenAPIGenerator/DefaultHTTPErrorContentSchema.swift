public import FeatherOpenAPI
public import OpenAPIKit30

public struct DefaultHTTPErrorContentSchema: ObjectSchemaRepresentable {
    public var openAPIIdentifier: String { "DefaultHTTPErrorContentSchema" }

    public var propertyMap: SchemaMap {
        [
            "message": Message(),
            "reason": Reason(),
        ]
    }
}

private struct Message: StringSchemaRepresentable {}

private struct Reason: StringSchemaRepresentable {}
