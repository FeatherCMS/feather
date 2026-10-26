import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Unsubscribe {
    struct Operation: OperationRepresentable {
        var operationId: String? { "appNewsletterCampaignUnsubscribe" }

        var tags: [any TagRepresentable] { [Campaign.Tag()] }
        var parameters: [any ParameterRepresentable] {
            [Campaign.Parameters.Key().reference()]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            Campaign.Subscribe.RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Subscriber unsubscribed")]
        }
    }
}
