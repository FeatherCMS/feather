import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile.CurrentUser.Put {
    struct Operation: Profile.CurrentUser.Operation {
        var operationId: String? { "accountCurrentUserProfileUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            Profile.Put.RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: Profile.Get.Response().reference()]
        }
    }
}
