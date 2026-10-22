import FeatherOpenAPI

extension Job.Schemas {
    struct Status: IntSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobStatusField" }
    }
}
