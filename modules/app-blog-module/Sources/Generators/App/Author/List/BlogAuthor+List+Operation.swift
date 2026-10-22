import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.List {
    struct Operation: BlogOperation {
        var operationId: String? { "blogAuthorList" }
        var responseMap: ResponseMap {
            [200: BlogAuthorListResponse().reference()]
        }
    }
}
