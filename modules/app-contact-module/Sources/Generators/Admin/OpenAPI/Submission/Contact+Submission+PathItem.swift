import FeatherOpenAPI

extension Contact.Submission {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? { List.Operation() }
        var delete: (any OperationRepresentable)? { Delete.Operation() }
    }
}

extension Contact.Submission.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Contact.Submission.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            Contact.Submission.Patch.Operation()
        }
    }
}
