import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsCategoryOperation: BearerProtectedOperation {}

extension NewsCategoryOperation {
    var tags: [any TagRepresentable] { [NewsCategoryTag()] }
}
