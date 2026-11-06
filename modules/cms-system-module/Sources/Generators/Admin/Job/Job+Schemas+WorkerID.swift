import FeatherOpenAPI

extension Job.Schemas {
    struct WorkerID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobWorkerIdField" }
    }
}
