import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.Patch {
    struct Operation: BlogAuthor.ID.Operation {
        var operationId: String? { "blogAuthorPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorDetailResponse().reference(),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
