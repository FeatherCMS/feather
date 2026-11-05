public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    public protocol Operation: BearerProtectedOperation {}
}

extension Settings.Operation {
    public var tags: [any TagRepresentable] { [Settings.Tag()] }
}
