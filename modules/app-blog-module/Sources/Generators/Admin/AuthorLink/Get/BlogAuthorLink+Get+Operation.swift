import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Get {
    struct Operation: BlogAuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkGet" }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorLinkDetailResponse().reference(),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
