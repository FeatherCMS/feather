import FeatherValidation

public enum AdminMetadataFieldValidator {

    public static func slug(
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

    public static func status(
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

    public static func title(
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
