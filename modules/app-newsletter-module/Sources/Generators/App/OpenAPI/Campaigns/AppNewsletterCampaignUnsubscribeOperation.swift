import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppNewsletterCampaignUnsubscribeOperation: OperationRepresentable {
    var tags: [any TagRepresentable] { [AppNewsletterTag()] }
    var parameters: [any ParameterRepresentable] {
        [AppNewsletterCampaignKeyParameter().reference()]
    }
    var requestBody: (any RequestBodyRepresentable)? {
        AppNewsletterCampaignSubscriptionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: NoContentResponse(description: "Subscriber unsubscribed")]
    }
}
