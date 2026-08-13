import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol NewsCategoryOperation: OperationRepresentable {}

extension NewsCategoryOperation {
    public var tags: [TagRepresentable] { [NewsContentTag()] }
}

struct NewsCategoryListOperation: NewsCategoryOperation {
    var responseMap: ResponseMap {
        [200: NewsCategoryListResponse().reference()]
    }
}

struct NewsCategoryGetOperation: NewsCategoryOperation {
    var parameters: [ParameterRepresentable] {
        [NewsCategoryIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: NewsCategoryDetailResponse().reference(),
            404: CustomResponse(description: "News category not found"),
        ]
    }
}
