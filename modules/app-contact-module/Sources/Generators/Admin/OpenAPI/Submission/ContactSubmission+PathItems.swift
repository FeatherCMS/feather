import FeatherOpenAPI

struct ContactFormSubmissionPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormSubmissionListOperation() }
    var delete: OperationRepresentable? {
        ContactFormSubmissionDeleteOperation()
    }
}
struct ContactFormSubmissionIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { ContactFormSubmissionGetOperation() }
    var patch: OperationRepresentable? {
        ContactFormSubmissionUpdateOperation()
    }
}
