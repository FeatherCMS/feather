import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile.CurrentUser.Get {
    struct Operation: Profile.CurrentUser.Operation {
        var operationId: String? { "accountCurrentUserProfileGet" }
        var responseMap: ResponseMap {
            [200: Profile.Get.Response().reference()]
        }
    }
}
