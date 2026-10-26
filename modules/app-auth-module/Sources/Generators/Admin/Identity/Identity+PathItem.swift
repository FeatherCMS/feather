import FeatherOpenAPI

extension Identity.Session {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}
