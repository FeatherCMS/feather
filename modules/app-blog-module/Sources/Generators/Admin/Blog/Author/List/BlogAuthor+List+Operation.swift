import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.List {
    struct Operation: BlogAuthor.Operation {
        var operationId: String? { "blogAuthorList" }
        var responseMap: ResponseMap {
            [200: BlogAuthorListResponse().reference()]
        }
    }
}
