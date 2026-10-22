import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

struct SettingsUpdateOperation: SettingsOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        SettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: SettingsDetailResponse().reference()
        ]
    }
}
