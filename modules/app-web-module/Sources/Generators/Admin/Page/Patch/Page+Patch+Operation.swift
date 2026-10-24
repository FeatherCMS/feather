import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension Page.Patch {
    struct Operation: Page.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "pagePatch" }

        var requestBody: (any RequestBodyRepresentable)? {
            PagePatchRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: PageDetailResponse().reference(),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
