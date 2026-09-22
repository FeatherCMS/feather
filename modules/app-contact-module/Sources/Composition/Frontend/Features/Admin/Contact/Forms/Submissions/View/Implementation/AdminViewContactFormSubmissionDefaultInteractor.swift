
struct AdminViewContactFormSubmissionDefaultInteractor:
    AdminViewContactFormSubmissionInteractor
{
    let repository: AdminViewContactFormSubmissionOpenAPIRepository
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    { try await repository.get(formId: formId, id: id) }
}
