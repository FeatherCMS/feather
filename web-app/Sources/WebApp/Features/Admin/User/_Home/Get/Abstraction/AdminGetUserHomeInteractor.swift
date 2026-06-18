import Hummingbird

protocol AdminGetUserHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetUserHomeModel
}
