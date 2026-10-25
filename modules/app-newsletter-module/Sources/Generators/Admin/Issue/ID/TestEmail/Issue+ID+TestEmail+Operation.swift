import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.ID.TestEmail {
    struct Operation: Issue.IDOperation {
        var operationId: String? { "newsletterIssueTestEmail" }

        var requestBody: (any RequestBodyRepresentable)? {
            Issue.TestEmail.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                204: NoContentResponse(description: "Test email queued"),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
