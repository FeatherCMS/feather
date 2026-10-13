import FeatherOpenAPI

struct ContactFormSubmissionPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        ContactFormSubmissionListOperation()
    }
    var delete: (any OperationRepresentable)? {
        ContactFormSubmissionRemoveOperation()
    }
}
struct ContactFormSubmissionIDPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? {
        ContactFormSubmissionGetOperation()
    }
    var patch: (any OperationRepresentable)? {
        ContactFormSubmissionUpdateOperation()
    }
}
