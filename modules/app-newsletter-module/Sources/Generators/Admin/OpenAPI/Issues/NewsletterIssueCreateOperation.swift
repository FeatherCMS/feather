import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueCreateOperation: NewsletterIssueOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterIssueCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsletterIssueResponse().reference()]
    }
}
