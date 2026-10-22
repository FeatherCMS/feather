import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Post {

    struct Operation: MagicLink.Operation {
        var operationId: String? { "authMagicLinkCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            MagicLink.Post.AuthMagicLinkManagementRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [201: MagicLink.Get.AuthMagicLinkDetailResponse().reference()]
        }
    }
}
