import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactFormFieldDefaultInteractor:
    AdminAddContactFormFieldInteractor
{
    let repository: AdminAddContactFormFieldOpenAPIRepository
    func getAddContactFormField(formId: String) async throws
        -> AdminAddContactFormFieldModel
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
    func postAddContactFormField(
        formId: String,
        payload: ContactFormFieldAddForm
    )
        async throws -> AdminAddContactFormFieldModel
    {
        do {
            try await repository.createField(formId: formId, form: payload)
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
