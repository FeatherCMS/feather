import FeatherOpenAPI

extension Contact.Form.Submission {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
