import Hummingbird

struct AdminGetAuthHomeDefaultInteractor: AdminGetAuthHomeInteractor {
    func getHome() async throws -> AdminGetAuthHomeModel {
        .init(title: "Auth module")
    }
}
