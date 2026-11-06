import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Post {
    struct Operation: Author.Operation {
        var operationId: String? { "blogAuthorPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Author.Get.Response().reference()]
        }
    }
}
