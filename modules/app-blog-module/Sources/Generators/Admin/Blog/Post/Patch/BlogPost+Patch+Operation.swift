import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Patch {
    struct Operation: BlogPost.ID.Operation {
        var operationId: String? { "blogPostPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogPostPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
