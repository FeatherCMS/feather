import AdminOpenAPI
import ContactApplication

extension AdminAPI {
    func contactFormSubmissionList(_ input: Operations.ContactFormSubmissionList.Input) async throws -> Operations.ContactFormSubmissionList.Output {
        try await modules.contact.authorize(permission: ContactPermissions.Submissions.list)
        let result = try await modules.contact.makeListContactFormSubmissions().execute(.init(formId: input.path.contactFormId))
        return .ok(.init(body: .json(result.map(map))))
    }
}
