import FeatherAdmin

protocol AdminRemoveContactSubmissionsPresenter: Sendable {
    func renderRemovePage(items: [NewAdminRemoveItemContext])
        async throws -> HTMLResponse
}
