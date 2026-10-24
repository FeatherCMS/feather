import FeatherOpenAPI

extension Contact.Submission.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormSubmissionListSchema" }
        var items: (any SchemaRepresentable)? {
            Contact.Submission.Get.Schema().reference()
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String {
            "ContactFormSubmissionListResponse"
        }
        var description: String = "Contact form submission list response"
        var schema = Schema().reference()
    }
}
