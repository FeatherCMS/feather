import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterSubscriberUpdateOperation: NewsletterSubscriberIDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            NewsletterCampaignKeyParameter().reference(),
            NewsletterSubscriberEmailParameter().reference(),
            NewsletterSubscriberUpdateMaskParameter().reference(),
        ]
    }
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterSubscriberPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterSubscriberResponse().reference(),
            400: DefaultHTTPErrorContentResponse(description: "Bad Request"),
            404: CustomResponse(description: "Newsletter subscriber not found"),
        ]
    }
}
