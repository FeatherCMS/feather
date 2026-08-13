import FeatherOpenAPI

struct ContactFormSubmissionResponse: JSONResponseRepresentable {
    var description: String = "Contact form submission response"
    var schema = ContactFormSubmissionSchema().reference()
}
struct ContactFormSubmissionListResponse: JSONResponseRepresentable {
    var description: String = "Contact form submission list response"
    var schema = ContactFormSubmissionListSchema().reference()
}
