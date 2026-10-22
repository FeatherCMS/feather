import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebSettingsUpdateOperation: WebSettingsOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        WebSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebSettingsDetailResponse().reference()
        ]
    }
}
