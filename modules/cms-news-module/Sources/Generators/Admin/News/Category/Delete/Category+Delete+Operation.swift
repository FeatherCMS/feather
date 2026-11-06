import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category.Delete {
    struct Operation: Category.Operation, DeleteOperation {
        var operationId: String? { "newsCategoryDelete" }
    }
}
