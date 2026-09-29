import FeatherOpenAPI

struct AppContactFormSubmissionPathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? { AppContactFormSubmissionOperation() }
}
struct AppContactFormGetPathItems: PathItemRepresentable {
    var get: (any OperationRepresentable)? { AppContactFormGetOperation() }
}
