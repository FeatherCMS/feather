import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign.Unsubscribe {
    struct Operation: OperationRepresentable {
        var operationId: String? { "appNewsletterCampaignUnsubscribe" }

        var tags: [any TagRepresentable] { [NewsletterCampaign.Tag()] }
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
}
