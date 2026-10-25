import FeatherOpenAPI

extension Settings {
    public struct ResponseSchema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsResponseSchema" }
        public var propertyMap: SchemaMap {
            [
                "language": Schemas.Language().reference(),
                "timezone": Schemas.Timezone().reference(),
                "pageSize": Schemas.PageSize().reference(),
            ]
        }

        public init() {}
    }
}
