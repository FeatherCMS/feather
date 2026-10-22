import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Put {
    struct Operation: AuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorLinkUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorLinkDetailResponse().reference(),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
