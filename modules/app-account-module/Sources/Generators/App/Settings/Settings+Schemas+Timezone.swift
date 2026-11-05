import FeatherOpenAPI

extension Settings.Schemas {
    public struct Timezone: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsTimezoneField" }
        public var example: String? = "UTC"
        public init() {}
    }
}
