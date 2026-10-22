import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Patch {
    struct Operation: Post.ID.Operation {
        var operationId: String? { "blogPostPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogPostIdParameter().reference(),
                Post.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogPostPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
