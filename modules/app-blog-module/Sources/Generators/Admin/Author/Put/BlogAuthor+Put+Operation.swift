import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.Put {
    struct Operation: BlogAuthor.ID.Operation {
        var operationId: String? { "blogAuthorPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorDetailResponse().reference(),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
