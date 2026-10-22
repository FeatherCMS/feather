import FeatherOpenAPIGenerator
import OpenAPIKit30
public import FeatherOpenAPI

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
