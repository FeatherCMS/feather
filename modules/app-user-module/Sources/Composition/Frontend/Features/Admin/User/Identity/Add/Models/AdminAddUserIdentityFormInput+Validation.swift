import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation

enum AdminAddUserIdentityFormFieldValidator {

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

extension AdminAddUserIdentityFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminAddUserIdentityFormFieldValidator.name(name)
            AdminAddUserIdentityFormFieldValidator.status(
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
