import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Category.List {
    struct Operation: Category.Operation {
        var operationId: String? { "newsCategoryList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
