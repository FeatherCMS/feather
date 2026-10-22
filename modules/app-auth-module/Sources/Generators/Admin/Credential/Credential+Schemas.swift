import FeatherOpenAPI
import OpenAPIKit30

extension Credential.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdField" }
        var example: String? = "credential_7nL3xQ2v"
    }
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUserIdField" }
        var example: String? = "user_7nL3xQ2v"
    }
    struct Email: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialEmailField" }
        var example: String? = "john.doe@example.com"
    }
    struct Password: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialPasswordField" }
        var example: String? = "correct-horse-battery-staple"
        var format: String? = "password"
    }
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialUpdateMaskField" }
        var example: String? = "userId,email,password"
    }
    struct IdentityName: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AuthCredentialIdentityNameField" }
        var example: String? = "Root User"
    }
}
