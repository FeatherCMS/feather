import FeatherValidation

enum SystemVariableFormFieldValidator {

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
            SystemVariableFormFieldValidator.name(name, required: true)
            SystemVariableFormFieldValidator.value(value, required: true)
            SystemVariableFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
