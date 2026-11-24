import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.Metadata.Edit.Input {
    private enum FieldValidator {

        static func slug(
            _ value: String?,
            required: Bool
        ) -> Validator<String> {
            .init(
                key: "slug",
                value: value,
                required: required,
                invocation: .all,
                rules: required
                    ? [.trimmedNonempty(message: "Slug is required.")]
                    : []
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

    private func validator(
        slugRequired: Bool
    ) -> GroupValidator {
        GroupValidator {
            FieldValidator.slug(
                slug,
                required: slugRequired
            )
            FieldValidator.template(
                template,
                required: true
            )
            FieldValidator.status(
                status,
                required: true
            )
        }
    }

    func validate(
        slugRequired: Bool
    ) async throws(ValidationError) {
        try await validator(slugRequired: slugRequired).validate()
    }

    func validationFailures(slugRequired: Bool) async -> [Failure] {
        await validator(slugRequired: slugRequired).failures()
    }
}
