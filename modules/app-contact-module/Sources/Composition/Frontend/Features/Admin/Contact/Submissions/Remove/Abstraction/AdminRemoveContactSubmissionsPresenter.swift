import FeatherAdmin

protocol AdminRemoveContactSubmissionsPresenter: Sendable {
    func renderRemovePage(items: [AdminRemoveItemContext])
        async throws -> HTMLResponse
}
