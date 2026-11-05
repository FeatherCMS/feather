import FeatherOpenAPI

extension Category.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsCategoryDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Category.Schemas.StringField(),
                "title": Category.Schemas.StringField(),
                "excerpt": Category.Schemas.StringField(),
                "content": Category.Schemas.StringField(),
                "imageAssetId": Category.Schemas.StringField()
                    .reference(required: false),
                "metadata": Metadata.Detail.Schema().reference(),
                "createdAt": Category.Schemas.TimestampField(),
                "updatedAt": Category.Schemas.TimestampField(),
            ]
        }
    }
}
