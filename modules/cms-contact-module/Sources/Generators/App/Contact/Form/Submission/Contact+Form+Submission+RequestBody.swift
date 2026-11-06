import FeatherOpenAPI

extension Contact.Form.Submission {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AppContactFormSubmissionRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
