protocol AdminAddContactFormFieldInteractor: Sendable {
    func getAddContactFormField(formId: String) async throws
        -> AdminAddContactFormFieldModel
    func postAddContactFormField(
        formId: String,
        payload: ContactFormFieldAddForm
    )
        async throws -> AdminAddContactFormFieldModel
}
