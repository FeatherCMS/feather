import FeatherOpenAPI
import OpenAPIKit30

extension Category.Schemas {
    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsCategoryCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "title": NewsAdminOpenAPIComponents.StringField(),
                "excerpt": NewsAdminOpenAPIComponents.StringField(),
                "content": NewsAdminOpenAPIComponents.StringField(),
                "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                    .reference(required: false),
                "metadata": Metadata.Input.Schema().reference(),
            ]
        }
    }
}
