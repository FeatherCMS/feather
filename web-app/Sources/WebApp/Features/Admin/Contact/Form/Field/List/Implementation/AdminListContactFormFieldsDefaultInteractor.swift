struct AdminListContactFormFieldsDefaultInteractor:
    AdminListContactFormFieldsInteractor
{
    let repository: AdminListContactFormFieldsOpenAPIRepository
    func list(formId: String) async throws -> [AdminContactFormFieldRow] {
        try await repository.list(formId: formId)
    }
}
