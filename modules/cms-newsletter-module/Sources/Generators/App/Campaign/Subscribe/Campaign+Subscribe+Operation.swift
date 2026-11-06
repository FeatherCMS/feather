import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Subscribe {
    struct Operation: OperationRepresentable {
        var operationId: String? { "appNewsletterCampaignSubscribe" }

        var tags: [any TagRepresentable] { [Campaign.Tag()] }
        var parameters: [any ParameterRepresentable] {
            [Campaign.Parameters.Key().reference()]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [204: NoContentResponse(description: "Subscriber added")]
        }
    }
}
