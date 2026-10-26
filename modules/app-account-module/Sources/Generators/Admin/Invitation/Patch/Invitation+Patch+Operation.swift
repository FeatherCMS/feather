import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Patch {
    struct Operation: Invitation.IdentifiableOperation, BearerProtectedOperation
    {
        var operationId: String? { "accountInvitationPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Invitation.Parameters.ID().reference(),
                Invitation.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Invitation.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: DefaultHTTPErrorContentResponse(
                    description: "Account invitation not found"
                ),
            ]
        }
    }
}
