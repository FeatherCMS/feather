import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.Get {
    struct Operation: Page.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "pageGet" }

        var responseMap: ResponseMap {
            [
                200: PageDetailResponse().reference(),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
