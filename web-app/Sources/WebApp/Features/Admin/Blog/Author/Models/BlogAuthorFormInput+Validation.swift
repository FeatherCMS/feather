import FeatherValidation

enum BlogAuthorFormFieldValidator {

    static func name(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "name",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Name is required.")
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
            rules: []
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

extension BlogAuthorFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            BlogAuthorFormFieldValidator.name(name, required: true)
            BlogAuthorFormFieldValidator.excerpt(excerpt, required: false)
            BlogAuthorFormFieldValidator.content(content, required: false)
            AdminMetadataFieldValidator.slug(
                key: "md_slug",
                value: metadataSlug,
                required: true
            )
            AdminMetadataFieldValidator.status(
                key: "md_status",
                value: effectiveMetadataStatus,
                required: true
            )
            AdminMetadataFieldValidator.title(
                key: "md_title",
                value: metadataTitle,
                required: false
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
