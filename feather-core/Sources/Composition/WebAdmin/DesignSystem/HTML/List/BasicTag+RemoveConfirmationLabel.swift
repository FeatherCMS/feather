public import HTML
public import SGML

extension GlobalAttributesModifier where Self: BasicTag {
    public func setAsRemoveConfirmationLabel(
        _ condition: Bool = true
    ) -> Self {
        guard condition else { return self }
        return data("remove-label", "true")
    }
}
