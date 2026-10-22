import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Post {

    struct Operation: MagicLink.Operation {
        var operationId: String? { "authMagicLinkCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            MagicLink.Post.RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [201: MagicLink.Get.Response().reference()]
        }
    }
}
