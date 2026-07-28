struct AdminEditContactFormSubmissionDefaultInteractor:
    AdminEditContactFormSubmissionInteractor
{
    let repository: AdminEditContactFormSubmissionOpenAPIRepository
    func update(formId: String, id: String, status: String) async throws {
        try await repository.update(formId: formId, id: id, status: status)
    }
}
