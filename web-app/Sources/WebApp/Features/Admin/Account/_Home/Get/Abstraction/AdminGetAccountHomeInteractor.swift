import Hummingbird

protocol AdminGetAccountHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetAccountHomeModel
}
