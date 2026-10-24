import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile.Put {
    struct Operation: Profile.Operation {
        var operationId: String? { "accountProfileUpdate" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: Profile.Get.Response().reference()]
        }
    }
}
