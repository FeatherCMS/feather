import FeatherOpenAPI
import FeatherOpenAPIGenerator

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
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                200: Page.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Page not found"),
            ]
        }
    }
}
