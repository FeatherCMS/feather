import FeatherContracts
import FeatherValidation

private enum SystemVariableAddFormValidator {
    static func key(_ value: String) -> Validator<String> {
        .init(
            key: "key",
            value: value,
            required: true,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Key is required."),
                .min(length: 2, message: "Key must be at least 2 characters."),
            ]
        )
    }

    static func name(_ value: String?) -> Validator<String> {
        .init(
            key: "name",
            value: value?.emptyToNil,
            required: false,
            invocation: .all,
            rules: [
                .min(
                    length: 4,
                    message: "Name must be at least 4 characters."
                ),
                .max(
                    length: 254,
                    message: "Name must be shorter than 255 characters."
                ),
            ]
        )
    }

    static func value(_ value: String) -> Validator<String> {
        .init(
            key: "value",
            value: value,
            required: false,
            invocation: .all,
            rules: [
                .max(
                    length: 254,
                    message: "Value must be shorter than 255 characters."
                )
            ]
        )
    }

    static func notes(_ value: String?) -> Validator<String> {
        .init(
            key: "notes",
            value: value?.emptyToNil,
            required: false,
            invocation: .all,
            rules: [
                .max(
                    length: 254,
                    message: "Notes must be shorter than 255 characters."
                )
            ]
        )
    }
}

extension SystemVariableAddFormInput {
    private var validator: GroupValidator {
        GroupValidator {
            SystemVariableAddFormValidator.key(key)
            SystemVariableAddFormValidator.value(value)
            SystemVariableAddFormValidator.name(name)
            SystemVariableAddFormValidator.notes(notes)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }
}
