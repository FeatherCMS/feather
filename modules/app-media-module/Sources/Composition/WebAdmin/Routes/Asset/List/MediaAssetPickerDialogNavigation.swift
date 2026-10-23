struct MediaAssetPickerDialogNavigation: Sendable {
    let field: String?
    let selectionMode: MediaAssetSelectionMode

    init(
        field: String?,
        selectionMode: MediaAssetSelectionMode = .single
    ) {
        self.field = field
        self.selectionMode = selectionMode
    }
}
