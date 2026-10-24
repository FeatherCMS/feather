import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Category.Put {
    struct Operation: Category.IdentifiableOperation {
        var operationId: String? { "newsCategoryPut" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Category.Get.Response().reference(),
                404: CustomResponse(description: "News category not found"),
            ]
        }
    }
}
