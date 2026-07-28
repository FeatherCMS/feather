import FeatherOpenAPI

struct AppContactFormSubmissionPathItems: PathItemRepresentable { var post: OperationRepresentable? { AppContactFormSubmissionOperation() } }
struct AppContactFormGetPathItems: PathItemRepresentable { var get: OperationRepresentable? { AppContactFormGetOperation() } }
struct AppContactNewsletterSubscribePathItems: PathItemRepresentable { var post: OperationRepresentable? { AppContactNewsletterSubscribeOperation() } }
struct AppContactNewsletterUnsubscribePathItems: PathItemRepresentable { var post: OperationRepresentable? { AppContactNewsletterUnsubscribeOperation() } }
