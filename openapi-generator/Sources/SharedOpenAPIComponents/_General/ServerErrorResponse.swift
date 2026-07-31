import FeatherOpenAPI
import OpenAPIKit30

public struct ServerErrorCodeField: IntSchemaRepresentable {}

public struct ServerErrorMessageField: StringSchemaRepresentable {}

public struct ServerErrorReasonField: StringSchemaRepresentable {}

public struct ServerErrorSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "code": ServerErrorCodeField(),
            "message": ServerErrorMessageField(),
            "reason": ServerErrorReasonField(),
        ]
    }
}

public struct ServerErrorResponse: JSONResponseRepresentable {
    public var description: String = "Server error response"
    public var schema = ServerErrorSchema().reference()

    public init() {}
}
