import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.MagicLink.Verify {
    struct Operation: Auth.Operation {
        var operationId: String? { "authMagicLinkVerify" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Auth.Response().reference(),
                401: CustomResponse(description: "Unauthorized"),
            ]
        }
    }
}
