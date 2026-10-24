import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared

extension FormField.Add.Interactor {
    struct Default: Interface {
        let repository: any FormField.Add.Repository.Interface

        func getAddContactField() async throws -> FormField.Add.Model {
            .init(
                key: "",
                type: "text",
                label: "",
                allowedValues: [],
                isRequired: false,
                position: "0",
                error: nil,
                fieldErrors: [:]
            )
        }
        func postAddContactField(
            payload: FormField.Add.Form.Input,
            formKey: String?
        ) async throws -> FormField.Add.Model {
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
                try await repository.createField(
                    form: payload,
                    assignToFormKey: formKey
                )
                return .init(
                    key: "",
                    type: "text",
                    label: "",
                    allowedValues: [],
                    isRequired: false,
                    position: "0",
                    error: nil,
                    fieldErrors: [:]
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw FormField.Add.Error.unauthorized
                case .forbidden:
                    throw FormField.Add.Error.forbidden
                case .conflict:
                    throw FormField.Add.Error.conflict
                case .notFound, .failure, .transport:
                    throw FormField.Add.Error.unavailable
                }
            }
            catch let error as FormField.Add.Error {
                throw error
            }
        }
    }
}
