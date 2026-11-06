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

    private var validator: GroupValidator {
        GroupValidator {
            FieldValidator.slug(
                slug,
                required: true
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

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
