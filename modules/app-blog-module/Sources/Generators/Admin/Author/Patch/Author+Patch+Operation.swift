import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Patch {
    struct Operation: Author.ID.Operation {
        var operationId: String? { "blogAuthorPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogAuthorIdParameter().reference(),
                Author.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogAuthorDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
