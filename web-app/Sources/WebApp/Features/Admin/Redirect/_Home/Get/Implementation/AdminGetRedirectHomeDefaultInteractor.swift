import Hummingbird

struct AdminGetRedirectHomeDefaultInteractor: AdminGetRedirectHomeInteractor {
    func getHome() async throws -> AdminGetRedirectHomeModel {
        .init(title: "Redirect module")
    }
}
