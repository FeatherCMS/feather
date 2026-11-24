import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.Page.Form {
    enum FieldValidator {

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
}

extension WebModule.Page.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            WebModule.Page.Form.FieldValidator.title(title, required: true)
            WebModule.Page.Form.FieldValidator.excerpt(excerpt, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
