import FeatherValidation

private enum SystemVariableEditFormValidator {
    static func key(_ value: String) -> Validator<String> {
        .init(
            key: "key",
            value: value,
            required: true,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Key is required."),
                .min(length: 2, message: "Key must be at least 2 characters.")
            ]
        )
    }

    static func name(_ value: String?) -> Validator<String> {
        .init(
            key: "name",
            value: value,
            required: false,
            invocation: .all,
            rules: []
        )
    }

    static func value(_ value: String) -> Validator<String> {
        .init(
            key: "value",
            value: value,
            required: false,
            invocation: .all,
            rules: []
        )
    }

    static func notes(_ value: String?) -> Validator<String> {
        .init(
            key: "notes",
            value: value,
            required: false,
            invocation: .all,
            rules: []
        )
    }
}

extension SystemVariableEditFormInput {
    private var validator: GroupValidator {
        GroupValidator {
            SystemVariableEditFormValidator.key(key)
            SystemVariableEditFormValidator.name(name)
            SystemVariableEditFormValidator.value(value)
            SystemVariableEditFormValidator.notes(notes)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

}
