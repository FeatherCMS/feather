import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.MenuItem.Form {
    enum FieldValidator {

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
}

extension WebModule.MenuItem.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            WebModule.MenuItem.Form.FieldValidator.label(label, required: true)
            WebModule.MenuItem.Form.FieldValidator.url(url, required: true)
            WebModule.MenuItem.Form.FieldValidator.priority(
                priority,
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

    func hasValidPermission(
        availablePermissions: Set<String>
    ) -> Bool {
        let permission = self.permission
        return permission.isEmpty || availablePermissions.contains(permission)
    }
}
