import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime

enum MetadataFormFieldValidator {

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

    static func template(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "template",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Template is required.")
            ]
        )
    }

}

extension MetadataFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            MetadataFormFieldValidator.slug(slug, required: true)
            MetadataFormFieldValidator.template(template, required: true)
            MetadataFormFieldValidator.status(status, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
