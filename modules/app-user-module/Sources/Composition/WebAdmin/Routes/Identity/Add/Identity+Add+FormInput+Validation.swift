public import FeatherValidation
public import UserModule

extension Identity.Add {
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
            .init(
                key: "status",
                value: value,
                required: required,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Status is required.")
                ]
            )
        }
    }
    }

    extension Identity.Add.FormInput {

    private var validator: GroupValidator {
        GroupValidator {
            Identity.Add.FormFieldValidator.name(name)
            Identity.Add.FormFieldValidator.status(
                status,
                required: true
            )
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
