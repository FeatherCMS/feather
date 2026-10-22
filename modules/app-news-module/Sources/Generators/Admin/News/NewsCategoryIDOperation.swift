import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsCategoryIDOperation: NewsCategoryOperation {}

extension NewsCategoryIDOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsCategoryIDParameter().reference()]
    }
}
