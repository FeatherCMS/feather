import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Patch {
    struct Operation: Email.Operation {
        var operationId: String? { "authEmailPatch" }

        var parameters: [any ParameterRepresentable] {
            [
                Email.Parameters.ID().reference(),
                Email.Parameters.UpdateMask().reference(),
            ]
        }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Email.Get.Response().reference(),
                400: CustomResponse(description: "Invalid update mask"),
                404: CustomResponse(description: "Auth email not found"),
            ]
        }
    }

}
