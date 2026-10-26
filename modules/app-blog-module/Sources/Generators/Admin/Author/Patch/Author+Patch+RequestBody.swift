import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "name": Author.Schemas.Name().reference(required: false),
                "excerpt": Author.Schemas.Excerpt().reference(required: false),
                "content": Author.Schemas.Content().reference(required: false),
                "profileImageAssetId": Author.Schemas.ProfileImageAssetID()
                    .nullable().reference(required: false),
            ]
        }
    }
}
