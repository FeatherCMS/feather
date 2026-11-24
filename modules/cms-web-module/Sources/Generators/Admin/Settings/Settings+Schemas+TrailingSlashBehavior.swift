import FeatherOpenAPI

extension Settings.Schemas {
    struct TrailingSlashBehavior: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "SettingsTrailingSlashBehaviorField"
        }

        var allowedValues: [String]? {
            ["enforce", "disable"]
        }

        var example: String? { "enforce" }
    }
}
