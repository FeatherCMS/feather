import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsletterSubscriberOperation: NewsletterCampaignOperation {}
extension NewsletterSubscriberOperation {
    var parameters: [ParameterRepresentable] {
        [NewsletterCampaignIdParameter().reference()]
    }
}
protocol NewsletterSubscriberIDOperation: NewsletterSubscriberOperation {}
extension NewsletterSubscriberIDOperation {
    var parameters: [ParameterRepresentable] {
        [
            NewsletterCampaignIdParameter().reference(),
            NewsletterSubscriberEmailParameter().reference(),
        ]
    }
}

struct NewsletterSubscriberListOperation: NewsletterSubscriberOperation {
    var responseMap: ResponseMap {
        [200: NewsletterSubscriberListResponse().reference()]
    }
}
struct NewsletterSubscriberCreateOperation: NewsletterSubscriberOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterSubscriberCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsletterSubscriberResponse().reference()]
    }
}
struct NewsletterSubscriberGetOperation: NewsletterSubscriberIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsletterSubscriberResponse().reference(),
            404: CustomResponse(description: "Newsletter subscriber not found"),
        ]
    }
}
struct NewsletterSubscriberUpdateOperation: NewsletterSubscriberIDOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsletterSubscriberPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterSubscriberResponse().reference(),
            404: CustomResponse(description: "Newsletter subscriber not found"),
        ]
    }
}
struct NewsletterSubscriberBulkDeleteOperation: NewsletterSubscriberOperation,
    BulkDeleteOperation
{
}
