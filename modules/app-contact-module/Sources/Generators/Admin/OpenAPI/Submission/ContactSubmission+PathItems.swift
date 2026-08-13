import FeatherOpenAPI

struct ContactFormSubmissionPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormSubmissionListOperation() }
    var delete: OperationRepresentable? {
        ContactFormSubmissionBulkDeleteOperation()
    }
}
struct ContactFormSubmissionIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormSubmissionGetOperation() }
    var patch: OperationRepresentable? {
        ContactFormSubmissionUpdateOperation()
    }
    var delete: OperationRepresentable? {
        ContactFormSubmissionDeleteOperation()
    }
}
