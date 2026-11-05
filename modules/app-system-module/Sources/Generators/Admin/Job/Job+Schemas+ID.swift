import FeatherOpenAPI

extension Job.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobIdField" }
    }
}
