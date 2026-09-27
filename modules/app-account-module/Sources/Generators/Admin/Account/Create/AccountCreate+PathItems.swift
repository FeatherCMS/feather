import FeatherOpenAPI

struct AccountCreatePathItems: PathItemRepresentable {
    var post: OperationRepresentable? {
        AccountCreateOperationDefinition()
    }
}
