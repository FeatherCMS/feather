import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueListOperation: NewsletterIssueOperation {
    var responseMap: ResponseMap {
        [200: NewsletterIssueListResponse().reference()]
    }
}
