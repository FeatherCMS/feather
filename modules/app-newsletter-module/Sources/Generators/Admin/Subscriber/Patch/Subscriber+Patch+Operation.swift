import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber.Patch {
    struct Operation: Subscriber.IDOperation {
        var operationId: String? { "newsletterSubscriberUpdate" }

        var parameters: [any ParameterRepresentable] {
            [
                Campaign.Parameters.Key().reference(),
                Subscriber.Parameters.Email().reference(),
                Subscriber.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Subscriber.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(
                    description: "Newsletter subscriber not found"
                ),
            ]
        }
    }
}
