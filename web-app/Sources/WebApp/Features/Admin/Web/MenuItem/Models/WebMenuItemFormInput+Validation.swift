import FeatherValidation

enum WebMenuItemFormFieldValidator {

    static func label(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "label",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Label is required.")
            ]
        )
    }

    static func url(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "url",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "URL is required.")
            ]
        )
    }

    static func priority(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "priority",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Priority is required.")
            ]
        )
    }
}

extension WebMenuItemFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            WebMenuItemFormFieldValidator.label(label, required: true)
            WebMenuItemFormFieldValidator.url(url, required: true)
            WebMenuItemFormFieldValidator.priority(priority, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
