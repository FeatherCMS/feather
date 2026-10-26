import FeatherOpenAPI

extension Rule.Schemas {
    struct Destination: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectDestinationField" }
        var example: String? { "/to-there/" }
    }
}
