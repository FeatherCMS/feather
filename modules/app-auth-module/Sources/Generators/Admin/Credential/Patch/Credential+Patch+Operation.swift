import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Patch {

    struct Operation: Credential.IdentifiableOperation {
        var operationId: String? { "authCredentialPatch" }

        var parameters: [any ParameterRepresentable] {
            [
                Credential.Parameters.AuthCredentialIdParameter().reference(),
                Credential.Parameters.AuthCredentialUpdateMaskParameter()
                    .reference(),
            ]
        }

        var requestBody: (any RequestBodyRepresentable)? {
            Credential.Patch.AuthCredentialPatchRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Credential.Get.AuthCredentialDetailResponse().reference(),
                400: CustomResponse(description: "Invalid update mask"),
                404: CustomResponse(description: "AuthCredential not found"),
            ]
        }
    }
}
