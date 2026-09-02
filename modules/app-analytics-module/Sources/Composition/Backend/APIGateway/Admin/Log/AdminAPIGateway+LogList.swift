import AnalyticsAdminAPI

extension AdminAPIGateway {

    public func analyticsLogList(
        _ input: Operations.AnalyticsLogList.Input
    ) async throws -> Operations.AnalyticsLogList.Output {
        .ok(
            .init(
                body: .json(
                    []
                )
            )
        )
    }
}
