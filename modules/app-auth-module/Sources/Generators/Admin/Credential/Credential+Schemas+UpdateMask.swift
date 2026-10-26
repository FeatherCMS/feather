import FeatherOpenAPI

extension Credential.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateMaskField" }
        var example: String? = "userId,email,password"
    }
}
