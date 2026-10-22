import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime

enum MenuFormFieldValidator {

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

extension MenuFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            MenuFormFieldValidator.key(key, required: true)
            MenuFormFieldValidator.name(name, required: true)
            MenuFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
