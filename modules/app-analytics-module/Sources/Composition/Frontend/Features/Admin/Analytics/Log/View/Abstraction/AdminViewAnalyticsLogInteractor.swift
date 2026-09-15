import FeatherAdmin
import Foundation

protocol AdminViewAnalyticsLogInteractor: Sendable {

    func execute(
        id: String
    ) async throws -> AdminViewAnalyticsLogModel
}
