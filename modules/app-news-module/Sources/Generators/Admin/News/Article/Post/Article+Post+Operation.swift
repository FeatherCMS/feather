import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article.Post {
    struct Operation: Article.Operation {
        var operationId: String? { "newsArticlePost" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Article.Get.Response().reference()]
        }
    }
}
