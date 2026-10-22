import FeatherOpenAPI

extension Rule.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleUpdateMask" }
        var example: String? = "source,destination,statusCode,notes"
    }
}
