import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogPost.Put {
    struct Operation: BlogPost.ID.Operation {
        var operationId: String? { "blogPostPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogPostUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogPostDetailResponse().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
