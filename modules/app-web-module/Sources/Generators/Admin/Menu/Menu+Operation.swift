import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu {
    protocol Operation: BearerProtectedOperation {}
}

extension Menu.Operation {
    var tags: [any TagRepresentable] { [Menu.Tag()] }
}
