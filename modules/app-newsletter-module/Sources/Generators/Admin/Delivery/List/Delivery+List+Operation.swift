import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Delivery.List {
    struct Operation: Issue.IDOperation {
        var operationId: String? { "newsletterIssueDeliveryList" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Newsletter issue not found"),
            ]
        }
    }
}
