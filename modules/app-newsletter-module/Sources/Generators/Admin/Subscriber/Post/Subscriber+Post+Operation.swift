import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber.Post {
    struct Operation: Subscriber.Operation {
        var operationId: String? { "newsletterSubscriberCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Subscriber.Get.Response().reference()]
        }
    }
}
