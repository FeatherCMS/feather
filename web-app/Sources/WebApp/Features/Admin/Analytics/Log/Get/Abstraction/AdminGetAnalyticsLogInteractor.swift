import Foundation

protocol AdminGetAnalyticsLogInteractor: Sendable {

    func execute(
        id: String
    ) async throws -> AdminGetAnalyticsLogModel
}
