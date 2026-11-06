import MediaModule

extension Asset.Picker.Dialog {
    struct Navigation: Sendable {
        let field: String?
        let selectionMode: Asset.Picker.SelectionMode

        init(
            field: String?,
            selectionMode: Asset.Picker.SelectionMode = .single
        ) {
            self.field = field
            self.selectionMode = selectionMode
        }
    }
}
