import FeatherValidation

enum WebMetadataFormFieldValidator {

    static func slug(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "slug",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Slug is required.")
            ]
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

extension WebMetadataFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            WebMetadataFormFieldValidator.slug(slug, required: true)
            WebMetadataFormFieldValidator.status(status, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
