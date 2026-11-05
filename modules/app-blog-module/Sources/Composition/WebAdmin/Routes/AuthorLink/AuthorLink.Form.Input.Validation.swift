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

extension AuthorLink.Form.Input {
    enum Validation {

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

    private var validator: GroupValidator {
        GroupValidator {
            Validation.label(label, required: true)
            Validation.url(url, required: true)
            Validation.priority(priority, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
