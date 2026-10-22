import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct SettingsGetOperation: SettingsOperation {
    var responseMap: ResponseMap {
        [
            200: SettingsDetailResponse().reference()
        ]
    }
}
