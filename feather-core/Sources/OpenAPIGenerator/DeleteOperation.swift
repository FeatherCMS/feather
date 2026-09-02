import FeatherOpenAPI
import OpenAPIKit30

struct DeleteIdField: StringSchemaRepresentable {
    var example: String? = "id1"
}

struct DeleteIdListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { DeleteIdField() }
}

struct DeleteOutputRequestField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct DeleteRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "ids": DeleteIdListSchema(),
            "results": DeleteOutputRequestField(),
            "summary": DeleteOutputRequestField(),
        ]
    }
}

struct DeleteResultStatusField: StringSchemaRepresentable {
    var allowedValues: [String]? = ["deleted", "not_found", "forbidden"]
    var example: String? = "deleted"
}

struct DeleteResultItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": DeleteIdField(),
            "status": DeleteResultStatusField(),
        ]
    }
}

struct DeleteResultListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { DeleteResultItemSchema() }
}

struct DeleteSummaryCountField: IntSchemaRepresentable {
    var example: Int? = 1
}

struct DeleteSummarySchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "requested": DeleteSummaryCountField(),
            "deleted": DeleteSummaryCountField(),
            "omitted": DeleteSummaryCountField(),
        ]
    }
}

struct DeleteResponseSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "results": DeleteResultListSchema().reference(required: false),
            "summary": DeleteSummarySchema().reference(required: false),
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

struct DeleteResponse: JSONResponseRepresentable {
    var description: String = "Delete response"
    var schema = DeleteResponseSchema().reference()
}

public protocol DeleteOperation: BearerProtectedOperation {

}

extension DeleteOperation {

    public var requestBody: RequestBodyRepresentable? {
        DeleteRequestBody().reference()
    }

    public var responseMap: ResponseMap {
        [
            200: DeleteResponse().reference()
        ]
    }
}
