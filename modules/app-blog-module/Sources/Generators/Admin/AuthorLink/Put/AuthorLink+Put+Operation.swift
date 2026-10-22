import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Put {
    struct Operation: AuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: AuthorLink.Get.Response().reference(),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
