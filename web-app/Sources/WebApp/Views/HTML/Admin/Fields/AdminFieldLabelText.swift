func adminFieldLabelText(
    _ label: String,
    required: Bool
) -> String {
    required ? "\(label) (required)" : label
}
