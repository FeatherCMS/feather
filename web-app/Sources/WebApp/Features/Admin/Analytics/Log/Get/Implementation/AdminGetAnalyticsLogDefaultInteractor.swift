import Foundation

struct AdminGetAnalyticsLogDefaultInteractor: AdminGetAnalyticsLogInteractor {
    private let repository: any AdminGetAnalyticsLogRepository

    init(repository: any AdminGetAnalyticsLogRepository) {
        self.repository = repository
    }

    func execute(
        id: String
    ) async throws -> AdminGetAnalyticsLogModel {
        .init(log: try await repository.get(id: id))
    }
}
