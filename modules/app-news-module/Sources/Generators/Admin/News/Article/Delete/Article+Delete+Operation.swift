import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article.Delete {
    struct Operation: Article.Operation, DeleteOperation {
        var operationId: String? { "newsArticleDelete" }
    }
}
