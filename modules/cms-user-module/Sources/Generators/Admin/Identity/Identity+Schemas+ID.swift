import FeatherOpenAPI

extension Identity.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityIDField" }
        var example: String? = "usr_a9x1f7Qk2m"
    }
}
