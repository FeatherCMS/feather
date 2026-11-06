import FeatherOpenAPI

extension Profile.Get {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountProfileResponseSchema" }
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
