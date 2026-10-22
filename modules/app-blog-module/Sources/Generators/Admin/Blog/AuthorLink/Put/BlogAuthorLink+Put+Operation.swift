import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Put {
    struct Operation: BlogAuthorLink.ID.Operation {
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
