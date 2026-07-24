struct AdminManageContactFormSubmissionRow: Sendable {
    let id: String
    let formId: String
    let status: String
    let createdAt: String
    let email: String?
    let values: [String: String]
}
