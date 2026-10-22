import FeatherValidation
import FeatherWebAdmin
import OpenAPIRuntime

enum PageFormFieldValidator {

    static func title(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "title",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Title is required.")
            ]
        )
    }

    static func content(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "content",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Content is required.")
            ]
        )
    }

    static func excerpt(
        _ value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: "excerpt",
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .max(length: 4000, message: "Excerpt is too long.")
            ]
        )
    }
}

extension PageFormInput {

    private var validator: GroupValidator {
        GroupValidator {
            PageFormFieldValidator.title(title, required: true)
            PageFormFieldValidator.excerpt(excerpt, required: false)
            PageFormFieldValidator.content(content, required: true)
        }
    }

    func validate() async throws(ValidationError) {
        try await validator.validate()
    }

    func validationFailures() async -> [Failure] {
        await validator.failures()
    }
}
