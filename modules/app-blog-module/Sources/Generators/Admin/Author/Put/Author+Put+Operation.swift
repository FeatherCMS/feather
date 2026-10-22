import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Put {
    struct Operation: Author.ID.Operation {
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
