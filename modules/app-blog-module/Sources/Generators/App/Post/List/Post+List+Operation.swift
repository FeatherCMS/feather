import BlogSchemaSupport
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.List {
    struct Operation: BlogOperation {
        var operationId: String? { "blogPostList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
