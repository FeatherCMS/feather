import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Article.Get {
    struct Operation: Article.IdentifiableOperation {
        var operationId: String? { "newsArticleGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "News article not found"),
            ]
        }
    }
}
