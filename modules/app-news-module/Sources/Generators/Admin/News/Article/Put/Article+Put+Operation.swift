import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article.Put {
    struct Operation: Article.IdentifiableOperation {
        var operationId: String? { "newsArticlePut" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Article.Get.Response().reference(),
                404: CustomResponse(description: "News article not found"),
            ]
        }
    }
}
