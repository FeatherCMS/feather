import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Menu {
    protocol Operation: BearerProtectedOperation {}
}

extension Menu.Operation {
    var tags: [any TagRepresentable] { [MenuTag()] }
}
