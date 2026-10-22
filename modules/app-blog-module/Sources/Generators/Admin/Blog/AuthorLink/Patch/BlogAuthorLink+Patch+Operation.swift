import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Patch {
    struct Operation: BlogAuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorLinkPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorLinkDetailResponse().reference(),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
