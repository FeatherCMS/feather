import Hummingbird

protocol AdminGetWebHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetWebHomeModel
}
