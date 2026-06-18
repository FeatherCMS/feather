import FeatherValidation

enum BlogAuthorLinkFormFieldValidator {

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

extension BlogAuthorLinkFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            BlogAuthorLinkFormFieldValidator.label(label, required: true)
            BlogAuthorLinkFormFieldValidator.url(url, required: true)
            BlogAuthorLinkFormFieldValidator.priority(priority, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
