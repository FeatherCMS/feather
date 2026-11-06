import FeatherOpenAPI

extension Permission.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SystemPermissionIDField" }
        var example: String? = "V1StGXR8_Z5jdHi6B-myT"
    }
}
