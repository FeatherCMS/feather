import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol WebSettingsOperation: BearerProtectedOperation {
}

extension WebSettingsOperation {
    public var tags: [TagRepresentable] { [WebSettingsTag()] }
}

struct WebSettingsGetOperation: WebSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: WebSettingsDetailResponse().reference()
        ]
    }
}

struct WebSettingsUpdateOperation: WebSettingsOperation {
    var requestBody: RequestBodyRepresentable? {
        WebSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebSettingsDetailResponse().reference()
        ]
    }
}
