import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber.Get {
    struct Operation: Subscriber.IDOperation {
        var operationId: String? { "newsletterSubscriberGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(
                    description: "Newsletter subscriber not found"
                ),
            ]
        }
    }
}
