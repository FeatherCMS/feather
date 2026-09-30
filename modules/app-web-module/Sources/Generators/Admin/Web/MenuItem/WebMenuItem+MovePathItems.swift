import FeatherOpenAPI

struct WebMenuItemMovePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { WebMenuItemMoveOperation() }
}
