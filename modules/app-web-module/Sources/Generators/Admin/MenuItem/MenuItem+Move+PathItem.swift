public import FeatherOpenAPI

extension MenuItem.Move {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { MenuItem.Move.Operation() }
    }
}
