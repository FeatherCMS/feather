import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

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
