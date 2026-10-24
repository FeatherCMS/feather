import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Patch {
    struct Operation: AuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                AuthorLink.Parameters.AuthorID().reference(),
                AuthorLink.Parameters.ID().reference(),
                AuthorLink.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: AuthorLink.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
