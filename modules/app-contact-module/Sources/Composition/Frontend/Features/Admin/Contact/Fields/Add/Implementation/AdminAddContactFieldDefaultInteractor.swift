import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
            error: nil,
            fieldErrors: [:]
        )
    }
    func postAddContactField(payload: ContactFieldFormInput)
        async throws -> AdminAddContactFieldModel
    {
        if let error = payload.allowedValuesValidationError {
            return .init(
                key: payload.key,
                type: payload.type,
                label: payload.label,
                allowedValues: payload.allowedValues,
                isRequired: payload.isRequiredValue,
                position: payload.position,
                error: nil,
                fieldErrors: ["allowedValues": error]
            )
        }
        do {
            try await repository.createField(form: payload)
            return .init(
                key: "",
                type: "text",
                label: "",
                allowedValues: "",
                isRequired: false,
                position: "0",
                error: nil,
                fieldErrors: [:]
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized:
                throw AdminAddContactFieldError.unauthorized
            case .forbidden:
                throw AdminAddContactFieldError.forbidden
            case .conflict:
                throw AdminAddContactFieldError.conflict
            case .notFound, .failure, .transport:
                throw AdminAddContactFieldError.unavailable
            }
        }
    }
}
