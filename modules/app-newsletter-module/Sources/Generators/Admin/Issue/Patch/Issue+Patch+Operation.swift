import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.Patch {
    struct Operation: Issue.IDOperation {
        var operationId: String? { "newsletterIssueUpdate" }

        var parameters: [any ParameterRepresentable] {
            [
                Campaign.Parameters.Key().reference(),
                Issue.Parameters.ID().reference(),
                Issue.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Issue.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
