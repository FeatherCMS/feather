import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppNewsletterTag: TagRepresentable {
    var name: String = "Newsletter"
    var description: String? = "Public newsletter endpoints."
}

struct AppNewsletterCampaignSubscribeOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppNewsletterTag()] }
    var parameters: [ParameterRepresentable] {
        [AppNewsletterCampaignKeyParameter().reference()]
    }
    var requestBody: RequestBodyRepresentable? {
        AppNewsletterCampaignSubscriptionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Subscriber added")]
    }
}
struct AppNewsletterCampaignUnsubscribeOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppNewsletterTag()] }
    var parameters: [ParameterRepresentable] {
        [AppNewsletterCampaignKeyParameter().reference()]
    }
    var requestBody: RequestBodyRepresentable? {
        AppNewsletterCampaignSubscriptionRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [204: CustomResponse(description: "Subscriber unsubscribed")]
    }
}
