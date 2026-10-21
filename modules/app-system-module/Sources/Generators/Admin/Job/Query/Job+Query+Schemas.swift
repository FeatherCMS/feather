import FeatherOpenAPI

extension Job.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Job.Schemas.ID(),
                "queueName": Job.Schemas.QueueName(),
                "status": Job.Schemas.Status(),
                "workerId": Job.Schemas.WorkerID()
                    .reference(
                        required: false
                    ),
                "lastModified": Job.Schemas.Timestamp(),
                "payload": Job.Schemas.Payload(),
            ]
        }
    }
}
