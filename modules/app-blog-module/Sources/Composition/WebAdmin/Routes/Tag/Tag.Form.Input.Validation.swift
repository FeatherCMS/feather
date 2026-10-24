import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension BlogModule.Tag.Form.Input {
    enum Validation {

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

    private var validator: GroupValidator {
        GroupValidator {
            Tag.Form.Input.Validation.title(title, required: true)
            Tag.Form.Input.Validation.excerpt(excerpt, required: false)
            Tag.Form.Input.Validation.content(content, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
