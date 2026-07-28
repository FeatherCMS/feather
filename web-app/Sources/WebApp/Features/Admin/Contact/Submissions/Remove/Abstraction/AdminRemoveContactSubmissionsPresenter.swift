import Hummingbird

protocol AdminRemoveContactSubmissionsPresenter: Sendable {
    func renderBulkConfirmation(selectedIds: [String], permissions: Set<String>)
        -> HTMLResponse
}
