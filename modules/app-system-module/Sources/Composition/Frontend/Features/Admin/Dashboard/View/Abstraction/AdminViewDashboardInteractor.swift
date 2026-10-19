import SystemModule
protocol AdminViewDashboardInteractor: Sendable {
    func getHome(
        context: AdminDashboardEventContext
    ) async throws -> AdminViewDashboardModel
}
