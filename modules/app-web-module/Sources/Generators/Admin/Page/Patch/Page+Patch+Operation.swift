import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.Patch {
    struct Operation: Page.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "pagePatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Page.Parameters.ID().reference(),
                Page.Parameters.UpdateMask().reference(),
            ]
        }

        var requestBody: (any RequestBodyRepresentable)? {
            PagePatchRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: PageDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
