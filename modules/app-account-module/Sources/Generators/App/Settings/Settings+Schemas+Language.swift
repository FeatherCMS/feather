import FeatherOpenAPI

extension Settings.Schemas {
    public struct Language: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsLanguageField" }
        public var example: String? = "en"
        public init() {}
    }
}
