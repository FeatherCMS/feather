import FeatherValidation

enum WebPageFormFieldValidator {

    static func title(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "title",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Title is required.")
            ]
        )
    }

    static func content(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "content",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Content is required.")
            ]
        )
    }

    static func excerpt(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "excerpt",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .max(length: 4000, message: "Excerpt is too long.")
            ]
        )
    }
}

extension WebPageFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            WebPageFormFieldValidator.title(title, required: true)
            WebPageFormFieldValidator.excerpt(excerpt, required: false)
            WebPageFormFieldValidator.content(content, required: true)
            AdminMetadataFieldValidator.slug(
                key: "md_slug",
                value: slug,
                required: true
            )
            AdminMetadataFieldValidator.status(
                key: "md_status",
                value: effectiveStatus,
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
