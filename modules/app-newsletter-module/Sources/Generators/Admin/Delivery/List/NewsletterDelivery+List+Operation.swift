import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterDelivery.List {
    struct Operation: NewsletterIssue.IDOperation {
        var operationId: String? { "newsletterIssueDeliveryList" }

        var responseMap: ResponseMap {
            [
                200: NewsletterDeliveryListResponse().reference(),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
