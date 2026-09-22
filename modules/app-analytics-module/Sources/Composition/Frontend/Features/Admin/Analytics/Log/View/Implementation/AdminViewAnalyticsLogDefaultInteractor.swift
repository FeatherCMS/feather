
struct AdminViewAnalyticsLogDefaultInteractor: AdminViewAnalyticsLogInteractor {
    private let repository: any AdminViewAnalyticsLogRepository

    init(repository: any AdminViewAnalyticsLogRepository) {
        self.repository = repository
    }

    func execute(
        id: String
    ) async throws -> AdminViewAnalyticsLogModel {
        .init(log: try await repository.get(id: id))
    }
}
