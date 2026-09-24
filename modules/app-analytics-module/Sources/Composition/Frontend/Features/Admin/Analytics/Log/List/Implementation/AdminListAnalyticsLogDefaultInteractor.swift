struct AdminListAnalyticsLogDefaultInteractor:
    AdminListAnalyticsLogInteractor
{
    let repository: any AdminListAnalyticsLogRepository

    func listAnalyticsLogs(
        page: Int,
        search: String?,
        source: String?,
        method: String?,
        responseCode: Int?,
        from: Double?,
        to: Double?
    ) async throws -> AdminListAnalyticsLogModel {
        try await repository.listAnalyticsLogs(
            page: page,
            search: search,
            source: source,
            method: method,
            responseCode: responseCode,
            from: from,
            to: to
        )
    }
}
