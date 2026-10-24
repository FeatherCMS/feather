import FeatherOpenAPI

extension Settings.Fields {
    public struct PageSize: IntSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsPageSizeField" }
        public var example: Int? = 20
        public init() {}
    }
}
