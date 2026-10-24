import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Category.Delete {
    struct Operation: Category.Operation, DeleteOperation {
        var operationId: String? { "newsCategoryDelete" }
    }
}
