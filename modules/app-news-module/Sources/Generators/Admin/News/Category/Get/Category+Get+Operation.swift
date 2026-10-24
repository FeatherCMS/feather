import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Category.Get {
    struct Operation: Category.IdentifiableOperation {
        var operationId: String? { "newsCategoryGet" }

        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "News category not found"),
            ]
        }
    }
}
