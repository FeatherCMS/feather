import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsletterSubscriberUpdateOperation: NewsletterSubscriberIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsletterSubscriberPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsletterSubscriberResponse().reference(),
            404: CustomResponse(description: "Newsletter subscriber not found"),
        ]
    }
}
