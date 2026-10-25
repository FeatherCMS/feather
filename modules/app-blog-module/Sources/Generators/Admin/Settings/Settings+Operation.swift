import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    protocol Operation: BearerProtectedOperation {}
}

extension Settings.Operation {
    var tags: [any TagRepresentable] { [Settings.Tag()] }
}
