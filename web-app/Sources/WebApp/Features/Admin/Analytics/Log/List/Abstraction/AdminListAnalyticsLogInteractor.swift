import Hummingbird

protocol AdminListAnalyticsLogInteractor: Sendable {

    func listAnalyticsLogs(
        page: Int,
        search: String?,
        source: String?,
        method: String?,
        responseCode: Int?
    ) async throws -> AdminListAnalyticsLogModel
}
