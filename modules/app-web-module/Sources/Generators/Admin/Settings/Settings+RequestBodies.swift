public import FeatherOpenAPI
import OpenAPIKit30

struct SettingsUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(SettingsUpdateSchema().reference())
        ]
    }
}
