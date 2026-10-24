import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Job.Get {
    struct Operation: Job.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "systemJobGet" }
        var responseMap: ResponseMap {
            [
                200: Job.Get.Response().reference(),
                404: DefaultHTTPErrorContentResponse(
                    description: "Worker job not found"
                ),
            ]
        }
    }
}
