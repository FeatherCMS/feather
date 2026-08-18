import FeatherOpenAPI

struct WebMenuItemMovePathItems: PathItemRepresentable {
    var post: OperationRepresentable? { WebMenuItemMoveOperation() }
}
