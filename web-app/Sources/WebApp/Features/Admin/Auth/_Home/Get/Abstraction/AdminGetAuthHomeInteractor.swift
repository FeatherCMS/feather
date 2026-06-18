import Hummingbird

protocol AdminGetAuthHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetAuthHomeModel
}
