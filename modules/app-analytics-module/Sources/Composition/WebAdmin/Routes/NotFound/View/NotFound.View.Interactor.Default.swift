import AnalyticsModule

extension NotFound.View.Interactor {
    struct Default: Interface {
        let repository: any NotFound.View.Repository.Interface

        func getOverview(
            from: Double,
            to: Double
        ) async throws -> Overview.Model {
            try await repository.getOverview(from: from, to: to)
        }
    }
}
