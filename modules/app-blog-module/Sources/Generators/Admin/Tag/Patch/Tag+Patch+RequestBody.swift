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
                "title": Tag.Schemas.Title().reference(required: false),
                "excerpt": Tag.Schemas.Excerpt().reference(required: false),
                "content": Tag.Schemas.Content().reference(required: false),
                "imageAssetId": Tag.Schemas.ImageAssetID()
                    .nullable().reference(required: false),
            ]
        }
    }
}
