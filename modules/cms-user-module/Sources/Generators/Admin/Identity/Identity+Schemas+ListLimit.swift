import FeatherOpenAPI

extension Identity.Schemas {
    struct ListLimit: IntSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityListLimit" }
        var description: String? {
            "Maximum number of identities. Defaults to 20; values are clamped to 1-100."
        }
        var defaultValue: Int? = 20
        var example: Int? = 100
    }
}
