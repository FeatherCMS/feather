public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

extension Rule {
    public protocol Operation: BearerProtectedOperation {
        var operationId: String? { get }
    }

    public protocol IDOperation: Operation {}
}

extension Rule.Operation {
    public var tags: [any TagRepresentable] { [Rule.Tag()] }
}

extension Rule.IDOperation {
    public var parameters: [any ParameterRepresentable] {
        [Rule.Parameters.ID().reference()]
    }
}
