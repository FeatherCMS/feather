import FeatherOpenAPI

extension Job.Schemas {
    struct Payload: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemJobPayloadField" }
    }
}
