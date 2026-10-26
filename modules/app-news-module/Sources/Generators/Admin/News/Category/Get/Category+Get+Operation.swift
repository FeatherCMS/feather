import FeatherOpenAPI
import FeatherOpenAPIGenerator

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
