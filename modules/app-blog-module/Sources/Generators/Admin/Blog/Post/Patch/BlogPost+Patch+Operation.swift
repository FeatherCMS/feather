import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Patch {
    struct Operation: BlogPost.ID.Operation {
        var operationId: String? { "blogPostPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogPostIdParameter().reference(),
                BlogPost.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogPostPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                400: CustomResponse(description: "Bad Request"),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
