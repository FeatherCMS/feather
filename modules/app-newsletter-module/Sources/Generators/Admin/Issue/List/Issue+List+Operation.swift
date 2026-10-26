import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue.List {
    struct Operation: Issue.Operation {
        var operationId: String? { "newsletterIssueList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
