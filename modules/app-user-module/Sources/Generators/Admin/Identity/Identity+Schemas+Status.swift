import FeatherOpenAPI

extension Identity.Schemas {
    struct Status: StringSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityStatusField" }
        var allowedValues: [String]? = [
            "invited",
            "active",
            "suspended",
            "deactivated",
            "anonymized",
        ]
        var example: String? = "active"
    }
}
