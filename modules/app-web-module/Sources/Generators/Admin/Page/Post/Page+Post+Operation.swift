import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.Post {
    struct Operation: Page.Operation, BearerProtectedOperation {
        var operationId: String? { "pageCreate" }

        var requestBody: (any RequestBodyRepresentable)? {
            PageRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                201: PageDetailResponse().reference()
            ]
        }
    }
}
