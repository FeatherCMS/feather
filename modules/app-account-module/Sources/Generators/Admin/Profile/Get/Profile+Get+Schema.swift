import FeatherOpenAPI

extension Profile.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileResponseSchema" }
        var propertyMap: SchemaMap {
            [
                "firstName": Profile.Fields.Name(required: false),
                "lastName": Profile.Fields.Name(required: false),
                "profileImageAssetId": Profile.Fields.ImageAssetID(
                    required: false
                ),
            ]
        }
    }
}
