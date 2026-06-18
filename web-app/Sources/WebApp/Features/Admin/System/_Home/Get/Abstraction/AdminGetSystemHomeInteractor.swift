import Hummingbird

protocol AdminGetSystemHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetSystemHomeModel
}
