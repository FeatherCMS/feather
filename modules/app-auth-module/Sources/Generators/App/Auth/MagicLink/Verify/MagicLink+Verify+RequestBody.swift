import FeatherOpenAPI
import OpenAPIKit30

extension Auth.MagicLink.Verify {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(RequestSchema().reference())]
        }
    }

    struct RequestSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            ["token": Auth.Schemas.MagicLinkTokenField().reference()]
        }
    }
}
