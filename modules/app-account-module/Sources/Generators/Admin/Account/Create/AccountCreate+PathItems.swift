import FeatherOpenAPI

struct AccountCreatePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AccountCreateOperationDefinition()
    }
}
