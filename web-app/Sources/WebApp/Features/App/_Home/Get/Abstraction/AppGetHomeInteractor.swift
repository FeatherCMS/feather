import Hummingbird

protocol AppGetHomeInteractor: Sendable {

    func getHome(
        account: AccountModel?
    ) async throws -> AppGetHomeModel
}
