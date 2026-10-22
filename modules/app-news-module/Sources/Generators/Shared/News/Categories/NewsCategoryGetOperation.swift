public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsCategoryGetOperation: NewsCategoryOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsCategoryIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: NewsCategoryDetailResponse().reference(),
            404: CustomResponse(description: "News category not found"),
        ]
    }
}
