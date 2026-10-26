import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article.Delete {
    struct Operation: Article.Operation, DeleteOperation {
        var operationId: String? { "newsArticleDelete" }
    }
}
