import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol AccountSettingsOperation: BearerProtectedOperation {}

extension AccountSettingsOperation {
    var tags: [TagRepresentable] { [AccountSettingsTag()] }
}

struct AccountSettingsGetOperation: AccountSettingsOperation {
    var responseMap: ResponseMap {
        [200: AccountSettingsDetailResponse().reference()]
    }
}

struct AccountSettingsUpdateOperation: AccountSettingsOperation {
    var requestBody: RequestBodyRepresentable? {
        AccountSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AccountSettingsDetailResponse().reference()]
    }
}
