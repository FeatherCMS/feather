import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.MagicLink {
    struct Operation: Auth.Operation {
        var operationId: String? { "authMagicLink" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Magic link requested")]
        }
    }
}
