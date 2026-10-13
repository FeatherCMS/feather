protocol AdminListAnalyticsLogInteractor: Sendable {

    func listAnalyticsLogs(
        page: Int,
        search: String?,
        source: String?,
        method: String?,
        responseCode: Int?,
        from: Double?,
        to: Double?
    ) async throws -> AdminListAnalyticsLogModel
}
