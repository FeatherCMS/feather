import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterIssueDeliveryListOperation: NewsletterIssueIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterDeliveryListResponse().reference(),
            404: CustomResponse(description: "Newsletter issue not found"),
        ]
    }
}
