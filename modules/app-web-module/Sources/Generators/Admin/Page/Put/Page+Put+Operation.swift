import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Page.Put {
    struct Operation: Page.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "pageUpdate" }

        var requestBody: (any RequestBodyRepresentable)? {
            PageUpdateRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: PageDetailResponse().reference(),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
