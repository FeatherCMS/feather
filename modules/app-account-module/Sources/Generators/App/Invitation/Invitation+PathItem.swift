import FeatherOpenAPI

extension Invitation {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Validate.Operation() }
        var post: (any OperationRepresentable)? { Exchange.Operation() }
    }
}
