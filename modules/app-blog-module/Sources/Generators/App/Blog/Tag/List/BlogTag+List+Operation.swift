import BlogSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.List {
    struct Operation: BlogOperation {
        var operationId: String? { "blogTagList" }
        var responseMap: ResponseMap {
            [200: BlogTagListResponse().reference()]
        }
    }
}
