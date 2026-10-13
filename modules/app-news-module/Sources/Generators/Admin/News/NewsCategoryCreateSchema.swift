import FeatherOpenAPI
import OpenAPIKit30

struct NewsCategoryCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "title": NewsAdminOpenAPIComponents.StringField(),
            "excerpt": NewsAdminOpenAPIComponents.StringField(),
            "content": NewsAdminOpenAPIComponents.StringField(),
            "imageAssetId": NewsAdminOpenAPIComponents.StringField()
                .reference(required: false),
            "metadata": NewsMetadataInputSchema().reference(),
        ]
    }
}
