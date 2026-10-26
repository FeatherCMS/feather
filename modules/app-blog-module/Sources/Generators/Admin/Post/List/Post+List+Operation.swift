import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.List {
    struct Operation: Post.Operation {
        var operationId: String? { "blogPostList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
