struct AdminAddContactFormItemDefaultInteractor:
    AdminAddContactFormItemInteractor
{
    let repository: AdminAddContactFormItemOpenAPIRepository
    func getAddContactFormItem(formId: String) async throws
        -> AdminAddContactFormItemModel
    {
        .init(
            formId: formId,
            key: "",
            type: "text",
            label: "",
            allowedValues: "",
            isRequired: false,
            position: "0",
            error: nil
        )
    }
    func postAddContactFormItem(formId: String, payload: ContactFormItemAddForm)
        async throws -> AdminAddContactFormItemModel
    {
        do {
            try await repository.createItem(formId: formId, form: payload)
            return .init(
                formId: formId,
                key: "",
                type: "text",
                label: "",
                allowedValues: "",
                isRequired: false,
                position: "0",
                error: nil
            )
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                formId: formId,
                key: payload.key,
                type: payload.type,
                label: payload.label,
                allowedValues: payload.allowedValues,
                isRequired: payload.isRequiredValue,
                position: payload.position,
                error: error.errorDescription
            )
        }
    }
}
