import FeatherOpenAPI

extension Job.Schemas {

    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobIdField" }
    }

    struct QueueName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobQueueNameField" }
    }

    struct Status: IntSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobStatusField" }
    }

    struct WorkerID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobWorkerIdField" }
    }

    struct Payload: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobPayloadField" }
    }

    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobTimestampField" }
    }

    struct PageSize: IntSchemaRepresentable {
        var example: Int? = 20
    }

    struct PageNumber: IntSchemaRepresentable {
        var example: Int? = 1
    }
}
