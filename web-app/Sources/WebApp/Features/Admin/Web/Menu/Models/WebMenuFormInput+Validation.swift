import FeatherValidation

enum WebMenuFormFieldValidator {

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

extension WebMenuFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            WebMenuFormFieldValidator.key(key, required: true)
            WebMenuFormFieldValidator.name(name, required: true)
            WebMenuFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
