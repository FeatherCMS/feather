public import FeatherOpenAPI
public import OpenAPIKit30

public struct ErrorTraceSchema: ObjectSchemaRepresentable {
    public var openAPIIdentifier: String { "ErrorTraceSchema" }

    public var propertyMap: SchemaMap {
        [
            "id": ID(),
            "message": Message(),
            "reasons": Reasons().reference(required: false),
        ]
    }
}

private struct ID: StringSchemaRepresentable {}

private struct Message: StringSchemaRepresentable {}

private struct Reasons: ArraySchemaRepresentable {
    var openAPIIdentifier: String { "ErrorTraceReasonsSchema" }

    var items: (any SchemaRepresentable)? {
        Reason().reference()
    }
}

private struct Reason: ObjectSchemaRepresentable {
    var openAPIIdentifier: String { "ErrorTraceReasonSchema" }

    var propertyMap: SchemaMap {
        [
            "id": ID(),
            "message": Message(),
        ]
    }
}
