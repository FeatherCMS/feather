import FeatherOpenAPI

extension Profile.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileUpdateSchema" }
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
