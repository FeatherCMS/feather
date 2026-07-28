import FeatherOpenAPI
import OpenAPIKit30

struct SystemJobIdField: StringSchemaRepresentable {}
struct SystemJobQueueNameField: StringSchemaRepresentable {}
struct SystemJobStatusField: IntSchemaRepresentable {}
struct SystemJobWorkerIdField: StringSchemaRepresentable {}
struct SystemJobPayloadField: StringSchemaRepresentable {}
struct SystemJobTimestampField: DoubleSchemaRepresentable {}

struct SystemJobSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": SystemJobIdField(),
            "queueName": SystemJobQueueNameField(),
            "status": SystemJobStatusField(),
            "workerId": SystemJobWorkerIdField().reference(required: false),
            "lastModified": SystemJobTimestampField(),
            "payload": SystemJobPayloadField(),
        ]
    }
}

struct SystemJobListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { SystemJobSchema().reference() }
}
