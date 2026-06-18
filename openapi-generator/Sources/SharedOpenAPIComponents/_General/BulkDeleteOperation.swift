import FeatherOpenAPI
import OpenAPIKit30

struct BulkDeleteIdField: StringSchemaRepresentable {
    var example: String? = "id1"
}

struct BulkDeleteIdListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { BulkDeleteIdField() }
}

struct BulkDeleteSummaryRequestField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct BulkDeleteRequestSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "ids": BulkDeleteIdListSchema(),
            "summary": BulkDeleteSummaryRequestField(),
        ]
    }
}

struct BulkDeleteResultStatusField: StringSchemaRepresentable {
    var allowedValues: [String]? = ["deleted", "not_found", "forbidden"]
    var example: String? = "deleted"
}

struct BulkDeleteResultItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": BulkDeleteIdField(),
            "status": BulkDeleteResultStatusField(),
        ]
    }
}

struct BulkDeleteResultListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { BulkDeleteResultItemSchema() }
}

struct BulkDeleteSummaryCountField: IntSchemaRepresentable {
    var example: Int? = 1
}

struct BulkDeleteSummarySchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "requested": BulkDeleteSummaryCountField(),
            "deleted": BulkDeleteSummaryCountField(),
            "notFound": BulkDeleteSummaryCountField(),
            "forbidden": BulkDeleteSummaryCountField(),
        ]
    }
}

struct BulkDeleteResponseSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "results": BulkDeleteResultListSchema(),
            "summary": BulkDeleteSummarySchema(),
        ]
    }
}

struct BulkDeleteRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BulkDeleteRequestSchema().reference())
        ]
    }
}

struct BulkDeleteResponse: JSONResponseRepresentable {
    var description: String = "Bulk delete response"
    var schema = BulkDeleteResponseSchema().reference()
}

public protocol BulkDeleteOperation: BearerProtectedOperation {

}

extension BulkDeleteOperation {

    public var requestBody: RequestBodyRepresentable? {
        BulkDeleteRequestBody().reference()
    }

    public var responseMap: ResponseMap {
        [
            200: BulkDeleteResponse().reference()
        ]
    }
}
