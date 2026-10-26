import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Post {
    struct Operation: Post.Operation {
        var operationId: String? { "blogPostPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Post.Get.Response().reference()]
        }
    }
}
