import FeatherOpenAPI

extension Profile.Put {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountProfileUpdateSchema" }
        public var propertyMap: SchemaMap {
            [
                "firstName": Profile.Schemas.Name(required: false),
                "lastName": Profile.Schemas.Name(required: false),
                "profileImageAssetId": Profile.Schemas.ImageAssetID(
                    required: false
                ),
            ]
        }

        public init() {}
    }
}
