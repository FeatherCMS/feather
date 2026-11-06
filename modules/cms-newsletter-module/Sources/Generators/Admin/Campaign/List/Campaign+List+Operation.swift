import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.List {
    struct Operation: Campaign.Operation {
        var operationId: String? { "newsletterCampaignList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
