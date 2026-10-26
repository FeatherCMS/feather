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

extension Author.Form.Input {
    enum Validation {

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

    private var validator: GroupValidator {
        GroupValidator {
            Validation.name(name, required: true)
            Validation.excerpt(excerpt, required: false)
            Validation.content(content, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
