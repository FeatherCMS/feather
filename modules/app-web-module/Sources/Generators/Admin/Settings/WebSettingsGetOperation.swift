import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

struct WebSettingsGetOperation: WebSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: WebSettingsDetailResponse().reference()
        ]
    }
}
