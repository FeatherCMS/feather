import Hummingbird

struct AdminGetAnalyticsHomeDefaultInteractor: AdminGetAnalyticsHomeInteractor {
    func getHome() async throws -> AdminGetAnalyticsHomeModel {
        .init(title: "Analytics module")
    }
}
