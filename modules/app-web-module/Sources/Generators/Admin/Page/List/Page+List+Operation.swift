import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.List {
    struct Operation: Page.Operation, BearerProtectedOperation {
        var operationId: String? { "pageList" }

        var responseMap: ResponseMap {
            [
                200: PageListResponse().reference()
            ]
        }
    }
}
