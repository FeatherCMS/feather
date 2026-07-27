protocol AdminListContactFormItemsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormItemRow]
}
