import FeatherOpenAPI

struct SiteSettingsTrailingSlashBehaviorField: StringSchemaRepresentable {
    var allowedValues: [String]? {
        ["enforce", "disable"]
    }

    var example: String? { "enforce" }

    init() {}
}
