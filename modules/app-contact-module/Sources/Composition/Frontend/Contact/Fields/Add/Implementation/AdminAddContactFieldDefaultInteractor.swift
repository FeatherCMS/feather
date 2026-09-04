import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddContactFieldDefaultInteractor:
    AdminAddContactFieldInteractor
{
    let repository: AdminAddContactFieldOpenAPIRepository
    func getAddContactField() async throws -> AdminAddContactFieldModel {
        .init(
            key: "",
            type: "text",
            label: "",
            allowedValues: "",
            isRequired: false,
            position: "0",
            error: nil
        )
    }
    func postAddContactField(payload: ContactFieldFormInput)
        async throws -> AdminAddContactFieldModel
    {
        do {
            try await repository.createField(form: payload)
            return .init(
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
