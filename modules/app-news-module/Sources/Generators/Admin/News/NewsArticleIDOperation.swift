import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsArticleIDOperation: NewsArticleOperation {}

extension NewsArticleIDOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsArticleIDParameter().reference()]
    }
}
