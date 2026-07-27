struct AdminListContactFormItemsDefaultInteractor:
    AdminListContactFormItemsInteractor
{
    let repository: AdminListContactFormItemsOpenAPIRepository
    func list(formId: String) async throws -> [AdminContactFormItemRow] {
        try await repository.list(formId: formId)
    }
}
