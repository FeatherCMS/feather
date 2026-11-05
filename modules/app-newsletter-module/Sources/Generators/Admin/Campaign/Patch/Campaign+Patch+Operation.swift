import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Patch {
    struct Operation: Campaign.IDOperation {
        var operationId: String? { "newsletterCampaignUpdate" }

        var parameters: [any ParameterRepresentable] {
            [
                Campaign.Parameters.ID().reference(),
                Campaign.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Campaign.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Newsletter not found"),
            ]
        }
    }
}
