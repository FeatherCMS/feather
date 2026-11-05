import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Get {
    struct Operation: Campaign.IDOperation {
        var operationId: String? { "newsletterCampaignGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Newsletter not found"),
            ]
        }
    }
}
