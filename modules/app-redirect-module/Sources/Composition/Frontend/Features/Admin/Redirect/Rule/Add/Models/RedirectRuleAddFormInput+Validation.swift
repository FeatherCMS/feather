import FeatherAdmin
import FeatherValidation
import RedirectContracts

enum RedirectRuleAddFormFieldValidator {

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
                .trimmedNonempty(message: "Status code is required."),
                .init(message: "Status code must be 301, 302, 307, or 308.") {
                    value in
                    guard let code = Int(value),
                        StatusCode(rawValue: code) != nil
                    else {
                        throw RuleError.invalid
                    }
                },
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

extension RedirectRuleAddFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            RedirectRuleAddFormFieldValidator.source(source, required: true)
            RedirectRuleAddFormFieldValidator.destination(
                destination,
                required: true
            )
            RedirectRuleAddFormFieldValidator.statusCode(
                statusCode,
                required: true
            )
            RedirectRuleAddFormFieldValidator.notes(notes, required: false)
        }
    }

    func validate() async throws(ValidationError) {
        let failures = await validator.failures()
        guard failures.isEmpty else {
            throw ValidationError(failures: failures)
        }
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
