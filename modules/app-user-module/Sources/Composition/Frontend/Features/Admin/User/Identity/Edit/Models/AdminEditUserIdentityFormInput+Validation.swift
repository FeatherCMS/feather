import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation

enum AdminEditUserIdentityFormFieldValidator {

    static func status(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        let hasValue = !(value ?? "")
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
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

extension AdminEditUserIdentityFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            AdminEditUserIdentityFormFieldValidator.status(
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
