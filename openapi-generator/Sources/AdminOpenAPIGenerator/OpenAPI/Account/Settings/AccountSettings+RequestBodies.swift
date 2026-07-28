import FeatherOpenAPI
import OpenAPIKit30

struct AccountSettingsUpdateRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [
            .json: Content(AccountSettingsUpdateSchema().reference())
        ]
    }
}
