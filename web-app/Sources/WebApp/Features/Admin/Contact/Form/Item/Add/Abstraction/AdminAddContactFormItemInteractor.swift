protocol AdminAddContactFormItemInteractor: Sendable {
    func getAddContactFormItem(formId: String) async throws -> AdminAddContactFormItemModel
    func postAddContactFormItem(formId: String, payload: ContactFormItemAddForm) async throws -> AdminAddContactFormItemModel
}
