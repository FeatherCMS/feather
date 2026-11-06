import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Post {
    struct Operation: Campaign.Operation {
        var operationId: String? { "newsletterCampaignCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Campaign.Get.Response().reference()]
        }
    }
}
