import FeatherOpenAPI

extension Profile.Put {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountProfileUpdateSchema" }
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
