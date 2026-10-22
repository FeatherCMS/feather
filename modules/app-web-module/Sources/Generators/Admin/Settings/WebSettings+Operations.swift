public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebSettingsOperation: BearerProtectedOperation {
}

extension WebSettingsOperation {
    public var tags: [any TagRepresentable] { [WebSettingsTag()] }
}

struct WebSettingsGetOperation: WebSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: WebSettingsDetailResponse().reference()
        ]
    }
}

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
