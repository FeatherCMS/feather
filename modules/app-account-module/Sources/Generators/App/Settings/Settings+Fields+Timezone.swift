import FeatherOpenAPI

extension Settings.Fields {
    public struct Timezone: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsTimezoneField" }
        public var example: String? = "UTC"
        public init() {}
    }
}
