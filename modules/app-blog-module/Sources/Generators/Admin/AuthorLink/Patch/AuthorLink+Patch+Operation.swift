import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Patch {
    struct Operation: AuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogAuthorLinkAuthorIdParameter().reference(),
                BlogAuthorLinkIdParameter().reference(),
                AuthorLink.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorLinkPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorLinkDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
