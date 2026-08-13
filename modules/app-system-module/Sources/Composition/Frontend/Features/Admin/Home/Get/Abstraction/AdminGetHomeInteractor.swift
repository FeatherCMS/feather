import FeatherAdmin

protocol AdminGetHomeInteractor: Sendable {
    func getHome(
        context: AdminDashboardEventContext
    ) async throws -> AdminGetHomeModel
}
