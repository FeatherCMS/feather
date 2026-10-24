import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Category.Post {
    struct Operation: Category.Operation {
        var operationId: String? { "newsCategoryPost" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Category.Get.Response().reference()]
        }
    }
}
