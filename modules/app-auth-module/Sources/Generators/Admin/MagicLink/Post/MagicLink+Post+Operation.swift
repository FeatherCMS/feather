import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Post {

    struct Operation: MagicLink.Operation {
        var operationId: String? { "authMagicLinkCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [201: MagicLink.Get.Response().reference()]
        }
    }
}
