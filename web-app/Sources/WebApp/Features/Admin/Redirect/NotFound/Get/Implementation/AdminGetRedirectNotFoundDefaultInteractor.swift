import AdminOpenAPI

struct AdminGetRedirectNotFoundDefaultInteractor:
    AdminGetRedirectNotFoundInteractor
{
    let repository: any AdminGetRedirectNotFoundRepository

    func getOverview(
        from: Double,
        to: Double
    ) async throws -> Components.Schemas.AnalyticsLogOverviewSchema {
        try await repository.getOverview(from: from, to: to)
    }
}
