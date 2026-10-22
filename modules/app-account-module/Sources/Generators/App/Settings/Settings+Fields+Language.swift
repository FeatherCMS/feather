import FeatherOpenAPI

extension Settings.Fields {
    public struct Language: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsLanguageField" }
        public var example: String? = "en"
        public init() {}
    }
}
