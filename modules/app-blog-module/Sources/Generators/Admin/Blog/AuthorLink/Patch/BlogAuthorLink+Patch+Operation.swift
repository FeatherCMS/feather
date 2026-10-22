import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Patch {
    struct Operation: BlogAuthorLink.ID.Operation {
        var operationId: String? { "blogAuthorLinkPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogAuthorLinkMenuIdParameter().reference(),
                BlogAuthorLinkIdParameter().reference(),
                BlogAuthorLink.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorLinkPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorLinkDetailResponse().reference(),
                400: CustomResponse(description: "Bad Request"),
                404: CustomResponse(description: "Blog author link not found"),
            ]
        }
    }
}
