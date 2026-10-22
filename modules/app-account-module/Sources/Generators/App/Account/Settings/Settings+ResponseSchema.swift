import FeatherOpenAPI

extension Settings {
    public struct ResponseSchema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsResponseSchema" }
        public var propertyMap: SchemaMap {
            [
                "language": Fields.Language().reference(),
                "timezone": Fields.Timezone().reference(),
                "pageSize": Fields.PageSize().reference(),
            ]
        }

        public init() {}
    }
}
