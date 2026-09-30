import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppNewsletterTag: TagRepresentable {
    var name: String = "Newsletter"
    var description: String? = "Public newsletter endpoints."
}

struct AppNewsletterCampaignSubscribeOperation: OperationRepresentable {
    var tags: [any TagRepresentable] { [AppNewsletterTag()] }
    var parameters: [any ParameterRepresentable] {
        [AppNewsletterCampaignKeyParameter().reference()]
    }
    var requestBody: (any RequestBodyRepresentable)? {
        AppNewsletterCampaignSubscriptionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Subscriber added")]
    }
}
struct AppNewsletterCampaignUnsubscribeOperation: OperationRepresentable {
    var tags: [any TagRepresentable] { [AppNewsletterTag()] }
    var parameters: [any ParameterRepresentable] {
        [AppNewsletterCampaignKeyParameter().reference()]
    }
    var requestBody: (any RequestBodyRepresentable)? {
        AppNewsletterCampaignSubscriptionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Subscriber unsubscribed")]
    }
}
