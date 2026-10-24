import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article.List {
    struct Operation: Article.Operation {
        var operationId: String? { "newsArticleList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
