import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Get {

    struct Operation: MagicLink.IdentifiableOperation {
        var operationId: String? { "authMagicLinkGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "AuthMagicLink not found"),
            ]
        }
    }
}
