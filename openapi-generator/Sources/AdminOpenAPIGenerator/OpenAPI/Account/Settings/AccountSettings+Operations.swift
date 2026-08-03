import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol AccountSettingsOperation: BearerProtectedOperation {
}

extension AccountSettingsOperation {
    public var tags: [TagRepresentable] { [AccountSettingsTag()] }
}

struct AccountSettingsGetOperation: AccountSettingsOperation {
    var responseMap: ResponseMap {
        [
            200: AccountSettingsDetailResponse().reference(),
            400: ServerErrorResponse().reference(),
            500: ServerErrorResponse().reference()
        ]
    }
}

struct AccountSettingsUpdateOperation: AccountSettingsOperation {
    var requestBody: RequestBodyRepresentable? {
        AccountSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AccountSettingsDetailResponse().reference(),
            400: ServerErrorResponse().reference(),
            500: ServerErrorResponse().reference()
        ]
    }
}
