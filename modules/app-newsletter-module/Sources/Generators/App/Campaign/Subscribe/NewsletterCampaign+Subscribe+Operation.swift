import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign.Subscribe {
    struct Operation: OperationRepresentable {
        var operationId: String? { "appNewsletterCampaignSubscribe" }

        var tags: [any TagRepresentable] { [NewsletterCampaign.Tag()] }
        var parameters: [any ParameterRepresentable] {
            [AppNewsletterCampaignKeyParameter().reference()]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            AppNewsletterCampaignSubscriptionRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Subscriber added")]
        }
    }
}
