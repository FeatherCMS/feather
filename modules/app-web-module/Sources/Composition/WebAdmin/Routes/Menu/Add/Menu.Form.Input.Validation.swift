import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.Menu.Form {
    enum FieldValidator {

        static func key(
            _ value: String?,
            required: Bool
        ) -> Validator<String> {
            .init(
                key: "key",
                value: value,
                required: required,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Key is required.")
                ]
            )
        }

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

        static func notes(
            _ value: String?,
            required: Bool
        ) -> Validator<String> {
            .init(
                key: "notes",
                value: value,
                required: required,
                invocation: .all,
                rules: []
            )
        }
    }
}

extension WebModule.Menu.Form.Input {

    private var validator: GroupValidator {
        GroupValidator {
            WebModule.Menu.Form.FieldValidator.key(key, required: true)
            WebModule.Menu.Form.FieldValidator.name(name, required: true)
            WebModule.Menu.Form.FieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
