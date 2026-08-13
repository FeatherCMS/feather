import FeatherAdmin
import FeatherValidation

enum SystemVariableFormFieldValidator {

    static func id(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "id",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "ID is required.")
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
            rules: []
        )
    }

    static func value(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "value",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Value is required.")
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

extension SystemVariableFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            SystemVariableFormFieldValidator.id(id, required: true)
            SystemVariableFormFieldValidator.name(name, required: false)
            SystemVariableFormFieldValidator.value(value, required: true)
            SystemVariableFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    public func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
