import AdminOpenAPI

extension AdminAPI {

    func analyticsLogFilters(
        _ input: Operations.AnalyticsLogFilters.Input
    ) async throws -> Operations.AnalyticsLogFilters.Output {
        .ok(
            .init(
                body: .json(
                    .init(
                        search: "",
                        source: "",
                        method: "",
                        responseCode: nil
                    )
                )
            )
        )
    }
}
