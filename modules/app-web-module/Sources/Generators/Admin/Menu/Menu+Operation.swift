import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Menu {
    protocol Operation: BearerProtectedOperation {}
}

extension Menu.Operation {
    var tags: [any TagRepresentable] { [MenuTag()] }
}
