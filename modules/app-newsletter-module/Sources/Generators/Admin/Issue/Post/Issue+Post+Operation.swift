import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.Post {
    struct Operation: Issue.Operation {
        var operationId: String? { "newsletterIssueCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Issue.Get.Response().reference()]
        }
    }
}
