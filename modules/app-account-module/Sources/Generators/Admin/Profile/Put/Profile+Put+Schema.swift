import FeatherOpenAPI

extension Profile.Put {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileUpdateSchema" }
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
