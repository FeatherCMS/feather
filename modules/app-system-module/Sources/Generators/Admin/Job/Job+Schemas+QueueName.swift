import FeatherOpenAPI

extension Job.Schemas {
    struct QueueName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobQueueNameField" }
    }
}
