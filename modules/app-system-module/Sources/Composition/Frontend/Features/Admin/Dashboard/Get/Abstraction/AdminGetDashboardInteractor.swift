import FeatherAdmin

protocol AdminGetDashboardInteractor: Sendable {
    func getHome(
        context: AdminDashboardEventContext
    ) async throws -> AdminGetDashboardModel
}
