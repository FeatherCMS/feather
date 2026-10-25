import FeatherOpenAPI

extension Category.List {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsCategoryListItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Category.Schemas.StringField(),
                "title": Category.Schemas.StringField(),
                "excerpt": Category.Schemas.StringField(),
                "imageAssetId": Category.Schemas.StringField()
                    .reference(required: false),
                "createdAt": Category.Schemas.TimestampField(),
                "updatedAt": Category.Schemas.TimestampField(),
            ]
        }
    }
}
