import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "title": BlogTagTitleField().reference(required: false),
                "excerpt": BlogTagExcerptField().reference(required: false),
                "content": BlogTagContentField().reference(required: false),
                "imageAssetId": BlogTagImageAssetIdField()
                    .nullable().reference(required: false),
            ]
        }
    }
}
