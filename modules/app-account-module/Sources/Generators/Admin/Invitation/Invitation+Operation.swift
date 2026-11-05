import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation {
    protocol Operation: OperationRepresentable {}
    protocol IdentifiableOperation: Operation {}
}

extension Invitation.Operation {
    var tags: [any TagRepresentable] { [Invitation.Tag()] }
}

extension Invitation.IdentifiableOperation {
    var parameters: [any ParameterRepresentable] {
        [Invitation.Parameters.ID().reference()]
    }
}
