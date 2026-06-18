import FeatherValidation

enum RedirectRuleFormFieldValidator {

    static func source(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "source",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Source is required.")
            ]
        )
    }

    static func destination(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "destination",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Destination is required.")
            ]
        )
    }

    static func statusCode(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "statusCode",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Status code is required.")
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

extension RedirectRuleFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            RedirectRuleFormFieldValidator.source(source, required: true)
            RedirectRuleFormFieldValidator.destination(
                destination,
                required: true
            )
            RedirectRuleFormFieldValidator.statusCode(
                statusCode,
                required: true
            )
            RedirectRuleFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
