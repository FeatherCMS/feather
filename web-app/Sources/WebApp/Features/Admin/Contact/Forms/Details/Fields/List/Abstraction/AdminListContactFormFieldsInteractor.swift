protocol AdminListContactFormFieldsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormFieldRow]
}
