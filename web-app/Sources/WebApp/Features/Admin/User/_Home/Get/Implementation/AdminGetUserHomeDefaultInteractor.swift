import Hummingbird

struct AdminGetUserHomeDefaultInteractor: AdminGetUserHomeInteractor {
    func getHome() async throws -> AdminGetUserHomeModel {
        .init(title: "User module")
    }
}
