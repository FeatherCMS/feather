import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsArticleOperation: BearerProtectedOperation {}

extension NewsArticleOperation {
    var tags: [any TagRepresentable] { [NewsArticleTag()] }
}
