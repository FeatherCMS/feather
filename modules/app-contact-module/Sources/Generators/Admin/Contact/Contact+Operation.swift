import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact {
    protocol Operation: BearerProtectedOperation {}
}

extension Contact.Operation {
    var tags: [any TagRepresentable] { [ContactFormsTag()] }
}
