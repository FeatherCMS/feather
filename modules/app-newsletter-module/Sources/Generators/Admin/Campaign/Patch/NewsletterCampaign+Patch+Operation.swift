import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterCampaign.Patch {
    struct Operation: NewsletterCampaign.KeyOperation {
        var operationId: String? { "newsletterCampaignUpdate" }

        var parameters: [any ParameterRepresentable] {
            [
                NewsletterCampaignKeyParameter().reference(),
                NewsletterCampaignUpdateMaskParameter().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            NewsletterCampaignPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: NewsletterCampaignResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Newsletter not found"),
            ]
        }
    }
}
