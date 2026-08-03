import Hummingbird

struct AdminGetAccountHomeDefaultInteractor: AdminGetAccountHomeInteractor {
    func getHome() async throws -> AdminGetAccountHomeModel {
        .init(title: "Account module")
    }
}
