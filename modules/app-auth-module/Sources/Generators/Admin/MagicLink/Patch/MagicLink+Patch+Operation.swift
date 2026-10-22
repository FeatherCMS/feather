import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Patch {

    struct Operation: MagicLink.IdentifiableOperation {
        var operationId: String? { "authMagicLinkPatch" }

        var parameters: [any ParameterRepresentable] {
            [
                MagicLink.Parameters.AuthMagicLinkIdParameter().reference(),
                MagicLink.Parameters.AuthMagicLinkUpdateMaskParameter()
                    .reference(),
            ]
        }

        var requestBody: (any RequestBodyRepresentable)? {
            MagicLink.Patch.AuthMagicLinkPatchRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: MagicLink.Get.AuthMagicLinkDetailResponse().reference(),
                400: CustomResponse(description: "Invalid update mask"),
                404: CustomResponse(description: "AuthMagicLink not found"),
            ]
        }
    }
}
