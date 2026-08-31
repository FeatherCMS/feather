import FeatherOpenAPI
import OpenAPIKit30

struct AdminAccountSettingsGetOperation: AdminAccountSettingsOperation {
    var responseMap: ResponseMap {
        [200: AccountSettingsDetailResponse().reference()]
    }
}

struct AdminAccountSettingsUpdateOperation: AdminAccountSettingsOperation {
    var requestBody: RequestBodyRepresentable? {
        AccountSettingsUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [200: AccountSettingsDetailResponse().reference()]
    }
}
