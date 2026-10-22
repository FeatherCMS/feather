import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.List {
    struct Operation: BlogTag.Operation {
        var operationId: String? { "blogTagList" }
        var responseMap: ResponseMap {
            [200: BlogTagListResponse().reference()]
        }
    }
}
