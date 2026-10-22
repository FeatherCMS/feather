import FeatherOpenAPI

extension Settings.Fields {
    public struct Language: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsLanguageField" }
        public var example: String? = "en"
        public init() {}
    }

    public struct Timezone: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsTimezoneField" }
        public var example: String? = "UTC"
        public init() {}
    }

    public struct PageSize: IntSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsPageSizeField" }
        public var example: Int? = 20
        public init() {}
    }
}
