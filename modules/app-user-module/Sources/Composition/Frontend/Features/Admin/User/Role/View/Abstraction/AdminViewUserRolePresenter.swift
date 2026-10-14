import FeatherAdmin

protocol AdminViewUserRolePresenter: Sendable {
    func renderDetailsPage(
        role: UserRoleDetailsModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse
    func renderErrorPage(error: AdminViewUserRoleError) async throws
        -> HTMLResponse
}
