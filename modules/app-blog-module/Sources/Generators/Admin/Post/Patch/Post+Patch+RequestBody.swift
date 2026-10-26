import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "title": Post.Schemas.Title().reference(required: false),
                "excerpt": Post.Schemas.Excerpt().reference(required: false),
                "content": Post.Schemas.Content().reference(required: false),
                "imageAssetId": Post.Schemas.ImageAssetID()
                    .nullable().reference(required: false),
                "authorIds": Post.Schemas.AuthorIDs()
                    .reference(required: false),
                "tagIds": Post.Schemas.TagIDs().reference(required: false),
            ]
        }
    }
}
