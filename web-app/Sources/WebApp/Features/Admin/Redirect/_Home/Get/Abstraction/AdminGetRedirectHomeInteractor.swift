import Hummingbird

protocol AdminGetRedirectHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetRedirectHomeModel
}
