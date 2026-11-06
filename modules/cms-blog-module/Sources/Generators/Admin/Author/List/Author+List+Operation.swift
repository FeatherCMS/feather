import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.List {
    struct Operation: Author.Operation {
        var operationId: String? { "blogAuthorList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
