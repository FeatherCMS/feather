import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Put {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "name": BlogAuthorNameField().reference(required: false),
                "excerpt": BlogAuthorExcerptField().reference(required: false),
                "content": BlogAuthorContentField().reference(required: false),
                "profileImageAssetId": BlogAuthorProfileImageAssetIdField()
                    .nullable().reference(required: false),
            ]
        }
    }
}
