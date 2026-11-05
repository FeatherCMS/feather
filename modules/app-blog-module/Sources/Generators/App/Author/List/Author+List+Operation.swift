import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.List {
    struct Operation: BlogOperation {
        var operationId: String? { "blogAuthorList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
