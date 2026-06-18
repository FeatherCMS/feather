import Hummingbird

protocol AdminGetHomeInteractor: Sendable {

    func getHome(
        permissions: Set<String>
    ) async throws -> AdminGetHomeModel
}
