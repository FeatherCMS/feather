import FeatherAdmin

protocol AdminViewUserRolePresenter: Sendable {
    func renderDetailsPage(
        role: UserRoleDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminViewUserRoleError) async throws
        -> HTMLResponse
}
