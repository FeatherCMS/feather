import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.Get {
    struct Operation: Page.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "pageGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
