import FeatherValidation

enum AdminMetadataFieldValidator {

    static func slug(
        key: String,
        value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: key,
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Slug is required.")
            ]
        )
    }

    static func status(
        key: String,
        value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: key,
            value: value,
            required: required,
            invocation: .all,
            rules: [
                .trimmedNonempty(message: "Status is required.")
            ]
        )
    }

    static func title(
        key: String,
        value: String?,
        required: Bool
    ) -> Validator<String> {
        .init(
            key: key,
            value: value,
            required: required,
            invocation: .all,
            rules:
                required
                ? [
                    .trimmedNonempty(message: "Title is required.")
                ]
                : []
        )
    }
}
