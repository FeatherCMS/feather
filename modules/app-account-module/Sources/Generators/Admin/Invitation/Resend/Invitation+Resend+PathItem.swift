import FeatherOpenAPI

extension Invitation.Resend {
    struct PathItem: PathItemRepresentable {
        var post: (any OperationRepresentable)? { Operation() }
    }
}
