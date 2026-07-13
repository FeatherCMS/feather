import FeatherOpenAPI
import OpenAPIKit30

struct AppContactFormSubmissionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap { [.json: Content(AppContactFormSubmissionSchema().reference())] }
}
struct AppContactNewsletterSubscriptionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap { [.json: Content(AppContactNewsletterSubscriptionSchema().reference())] }
}
