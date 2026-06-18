import FeatherOpenAPI
import OpenAPIKit30

struct WebSettingsUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(WebSettingsUpdateSchema().reference())
        ]
    }
}
