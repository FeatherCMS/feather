import FeatherOpenAPI

struct AppContactFormSubmissionPathItems: PathItemRepresentable {
    var post: OperationRepresentable? { AppContactFormSubmissionOperation() }
}
struct AppContactFormGetPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { AppContactFormGetOperation() }
}
