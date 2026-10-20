import FeatherModuleKit
import FeatherValidation
import UserModule

extension Identity.Edit {
    enum FormFieldValidator {

        static func name(_ value: String?) -> Validator<String> {
            .init(
                key: "name",
                value: value,
                required: true,
                invocation: .all,
                rules: [.trimmedNonempty(message: "Name is required.")]
            )
        }

        static func status(
            _ value: String?,
            required: Bool
        ) -> Validator<String> {
            let hasValue = !(value ?? "")
                .whitespaceTrimmed
                .isEmpty
            return .init(
                key: "status",
                value: value,
                required: required,
                invocation: .all,
                rules: hasValue
                    ? [
                        .trimmedNonempty(message: "Status is required.")
                    ]
                    : []
            )
        }
    }
}

extension Identity.Edit.FormInput {

    private var validator: GroupValidator {
        GroupValidator {
            Identity.Edit.FormFieldValidator.name(name)
            Identity.Edit.FormFieldValidator.status(
                status,
                required: true
            )
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
