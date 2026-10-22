import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol ContactFormOperation: BearerProtectedOperation {}

extension ContactFormOperation {
    var tags: [any TagRepresentable] { [ContactFormsTag()] }
}
