import Hummingbird

protocol AdminGetMediaHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetMediaHomeModel
}
