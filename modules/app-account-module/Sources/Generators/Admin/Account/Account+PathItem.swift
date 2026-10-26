import FeatherOpenAPI

extension Account {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Create.Operation() }
    }
}
