import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.Put {
    struct Operation: Page.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "pageUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Page.Get.Response().reference(),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
