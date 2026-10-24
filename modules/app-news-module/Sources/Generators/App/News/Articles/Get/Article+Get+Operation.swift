import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article.Get {
    struct Operation: Article.IdentifiableOperation {
        var operationId: String? { "newsArticleGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "News item not found"),
            ]
        }
    }
}
