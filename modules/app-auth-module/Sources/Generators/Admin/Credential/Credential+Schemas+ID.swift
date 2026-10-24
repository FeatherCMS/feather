import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdField" }
        var example: String? = "credential_7nL3xQ2v"
    }
}
