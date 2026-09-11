import FeatherValidation

private enum SystemVariableEditFormValidator {
    static func id(_ value: String) -> Validator<String> {
        .init(key: "id", value: value, required: true, invocation: .all, rules: [.trimmedNonempty(message: "ID is required.")])
    }

    static func name(_ value: String?) -> Validator<String> {
        .init(key: "name", value: value, required: false, invocation: .all, rules: [])
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
        .init(key: "notes", value: value, required: false, invocation: .all, rules: [])
    }
}

extension SystemVariableEditFormInput {
    private var validator: GroupValidator {
        GroupValidator {
            SystemVariableEditFormValidator.id(id)
            SystemVariableEditFormValidator.name(name)
            SystemVariableEditFormValidator.value(value)
            SystemVariableEditFormValidator.notes(notes)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

}
