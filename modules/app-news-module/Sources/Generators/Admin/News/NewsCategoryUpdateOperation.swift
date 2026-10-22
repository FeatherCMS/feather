import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsCategoryUpdateOperation: NewsCategoryIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        NewsCategoryUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsCategoryDetailResponse().reference(),
            404: CustomResponse(description: "News category not found"),
        ]
    }
}
