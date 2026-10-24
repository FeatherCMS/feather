import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Category.List {
    struct Operation: Category.Operation {
        var operationId: String? { "newsCategoryList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
