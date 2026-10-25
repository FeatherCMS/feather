import FeatherOpenAPI

extension Category.Schemas {
    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsCategoryCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "title": StringField(),
                "excerpt": StringField(),
                "content": StringField(),
                "imageAssetId": StringField()
                    .reference(required: false),
                "metadata": Metadata.Input.Schema().reference(),
            ]
        }
    }
}
