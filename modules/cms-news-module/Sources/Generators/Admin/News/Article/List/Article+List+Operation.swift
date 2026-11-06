import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article.List {
    struct Operation: Article.Operation {
        var operationId: String? { "newsArticleList" }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
