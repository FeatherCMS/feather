import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Get {
    struct Operation: AuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkGet" }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorLinkDetailResponse().reference(),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
