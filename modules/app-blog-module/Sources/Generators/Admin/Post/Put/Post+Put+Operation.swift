import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Put {
    struct Operation: Post.ID.Operation {
        var operationId: String? { "blogPostPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Post.Get.Response().reference(),
                404: CustomResponse(description: "Blog post not found"),
            ]
        }
    }
}
