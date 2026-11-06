import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Put {

    struct Operation: MagicLink.IdentifiableOperation {
        var operationId: String? { "authMagicLinkUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MagicLink.Get.Response().reference(),
                404: CustomResponse(description: "AuthMagicLink not found"),
            ]
        }
    }
}
