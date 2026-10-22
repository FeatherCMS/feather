import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct WebSettingsGetOperation: WebSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: WebSettingsDetailResponse().reference()
        ]
    }
}
