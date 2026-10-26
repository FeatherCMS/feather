import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Credential.Patch {

    struct Operation: Credential.IdentifiableOperation {
        var operationId: String? { "authCredentialPatch" }

        var parameters: [any ParameterRepresentable] {
            [
                Credential.Parameters.ID().reference(),
                Credential.Parameters.UpdateMask()
                    .reference(),
            ]
        }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Credential.Get.Response().reference(),
                400: CustomResponse(description: "Invalid update mask"),
                404: CustomResponse(description: "AuthCredential not found"),
            ]
        }
    }
}
