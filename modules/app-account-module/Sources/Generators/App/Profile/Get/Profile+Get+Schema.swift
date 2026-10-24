import FeatherOpenAPI

extension Profile.Get {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountProfileResponseSchema" }
        public var propertyMap: SchemaMap {
            [
                "firstName": Profile.Fields.Name(required: false),
                "lastName": Profile.Fields.Name(required: false),
                "profileImageAssetId": Profile.Fields.ImageAssetID(
                    required: false
                ),
            ]
        }

        public init() {}
    }
}
