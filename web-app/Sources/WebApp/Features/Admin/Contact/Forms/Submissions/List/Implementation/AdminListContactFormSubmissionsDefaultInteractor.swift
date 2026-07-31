struct AdminListContactFormSubmissionsDefaultInteractor:
    AdminListContactFormSubmissionsInteractor
{
    let repository: AdminListContactFormSubmissionsOpenAPIRepository
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem] {
        try await repository.list(formId: formId)
    }
}
