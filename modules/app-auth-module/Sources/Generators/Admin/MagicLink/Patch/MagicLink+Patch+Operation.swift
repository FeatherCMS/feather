import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Patch {

    struct Operation: MagicLink.IdentifiableOperation {
        var operationId: String? { "authMagicLinkPatch" }

        var parameters: [any ParameterRepresentable] {
            [
                MagicLink.Parameters.ID().reference(),
                MagicLink.Parameters.UpdateMask()
                    .reference(),
            ]
        }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MagicLink.Get.Response().reference(),
                400: CustomResponse(description: "Invalid update mask"),
                404: CustomResponse(description: "AuthMagicLink not found"),
            ]
        }
    }
}
