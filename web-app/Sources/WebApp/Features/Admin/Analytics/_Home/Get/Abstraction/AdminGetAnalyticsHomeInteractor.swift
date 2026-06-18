import Hummingbird

protocol AdminGetAnalyticsHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetAnalyticsHomeModel
}
