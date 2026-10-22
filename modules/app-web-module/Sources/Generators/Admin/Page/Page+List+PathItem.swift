import FeatherOpenAPI

extension Page.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { WebPageListOperation() }
    }
}
