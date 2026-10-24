import FeatherOpenAPI

extension Asset.Folder.List {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { Operation() }
    }
}
