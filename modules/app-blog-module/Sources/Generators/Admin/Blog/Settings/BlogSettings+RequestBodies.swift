import FeatherOpenAPI
import OpenAPIKit30

struct BlogSettingsUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(BlogSettingsUpdateSchema().reference())
        ]
    }
}
