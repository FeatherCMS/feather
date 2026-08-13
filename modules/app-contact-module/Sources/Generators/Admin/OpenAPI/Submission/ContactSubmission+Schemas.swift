import FeatherOpenAPI
import OpenAPIKit30

struct ContactStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = ["received", "processed", "spam", "failed"]
}
struct ContactFormSubmissionSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "formId": ContactIdField(),
            "values": ContactJSONField(),
            "itemsSnapshot": ContactJSONField(),
            "metadata": ContactJSONField(),
            "status": ContactStatusField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}
struct ContactFormSubmissionListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        ContactFormSubmissionSchema().reference()
    }
}
struct ContactFormSubmissionPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap { ["status": ContactStatusField()] }
}
