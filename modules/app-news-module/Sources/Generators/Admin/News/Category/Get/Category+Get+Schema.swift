import FeatherOpenAPI

extension Category.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsCategoryDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": NewsAdminOpenAPIComponents.StringField(),
                "title": NewsAdminOpenAPIComponents.StringField(),
                "excerpt": NewsAdminOpenAPIComponents.StringField(),
                "content": NewsAdminOpenAPIComponents.StringField(),
                "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                    .reference(required: false),
                "metadata": Metadata.Detail.Schema().reference(),
                "createdAt": NewsAdminOpenAPIComponents.TimestampField(),
                "updatedAt": NewsAdminOpenAPIComponents.TimestampField(),
            ]
        }
    }
}
