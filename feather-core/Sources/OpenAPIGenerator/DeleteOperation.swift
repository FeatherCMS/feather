public import FeatherOpenAPI

struct DeleteIdField: StringSchemaRepresentable {
    var example: String? = "id1"
}

struct DeleteIdListSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? { DeleteIdField() }
}

struct DeleteRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "ids": DeleteIdListSchema()
        ]
    }
}

struct DeleteRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(DeleteRequestSchema().reference())
        ]
    }
}

public protocol DeleteOperation: BearerProtectedOperation {

}

extension DeleteOperation {

    public var requestBody: (any RequestBodyRepresentable)? {
        DeleteRequestBody().reference()
    }

    public var responseMap: ResponseMap {
        [
            204: NoContentResponse(description: "Delete succeeded").reference()
        ]
    }
}
