import FeatherOpenAPI
import OpenAPIKit30

extension Job.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Job.Schemas.ID(),
                "queueName": Job.Schemas.QueueName(),
                "status": Job.Schemas.Status(),
                "workerId": Job.Schemas.WorkerID().reference(required: false),
                "lastModified": Job.Schemas.Timestamp(),
                "payload": Job.Schemas.Payload(),
            ]
        }
    }
}
