import FeatherValidation

private enum SystemVariableAddFormValidator {
    static func key(_ value: String) -> Validator<String> {
        .init(
            key: "key",
            value: value,
            required: true,
            invocation: .all,
            rules: [.trimmedNonempty(message: "Key is required.")]
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
            required: true,
            invocation: .all,
            rules: [.trimmedNonempty(message: "Value is required.")]
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

extension SystemVariableAddFormInput {
    private var validator: GroupValidator {
        GroupValidator {
            SystemVariableAddFormValidator.key(key)
            SystemVariableAddFormValidator.name(name)
            SystemVariableAddFormValidator.value(value)
            SystemVariableAddFormValidator.notes(notes)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

}
