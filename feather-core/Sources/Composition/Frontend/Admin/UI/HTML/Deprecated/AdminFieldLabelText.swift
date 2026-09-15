@available(*, deprecated, message: "Use NewAdminFormFieldLabel instead.")
public func adminFieldLabelText(
    _ label: String,
    required: Bool
) -> String {
    required ? label : "\(label) (Optional)"
}
