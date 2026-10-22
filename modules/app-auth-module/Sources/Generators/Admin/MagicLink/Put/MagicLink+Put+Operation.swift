import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Put {

    struct Operation: MagicLink.IdentifiableOperation {
        var operationId: String? { "authMagicLinkUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            MagicLink.Put.AuthMagicLinkUpdateRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MagicLink.Get.AuthMagicLinkDetailResponse().reference(),
                404: CustomResponse(description: "AuthMagicLink not found"),
            ]
        }
    }
}
