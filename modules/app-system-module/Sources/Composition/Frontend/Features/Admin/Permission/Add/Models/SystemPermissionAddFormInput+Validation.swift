import FeatherValidation

extension SystemPermissionAddFormInput {
    func validate() async throws(ValidationError) {
        try await GroupValidator {
            Validator(
                key: "key",
                value: key,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Key is required."),
                    .min(
                        length: 2,
                        message: "Key must be at least 2 characters."
                    ),
                ]
            )
        }
        .validate()
    }
}
