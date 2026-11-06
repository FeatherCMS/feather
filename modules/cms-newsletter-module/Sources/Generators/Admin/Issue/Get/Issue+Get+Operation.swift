import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.Get {
    struct Operation: Issue.IDOperation {
        var operationId: String? { "newsletterIssueGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
