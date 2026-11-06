import FeatherOpenAPI

extension Profile.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileResponseSchema" }
        var propertyMap: SchemaMap {
            [
                "firstName": Profile.Schemas.Name(required: false),
                "lastName": Profile.Schemas.Name(required: false),
                "profileImageAssetId": Profile.Schemas.ImageAssetID(
                    required: false
                ),
            ]
        }
    }
}
