public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

extension Email {
    public protocol Operation: BearerProtectedOperation {}
}

extension Email.Operation {
    public var tags: [any TagRepresentable] { [Email.Tag()] }
}
