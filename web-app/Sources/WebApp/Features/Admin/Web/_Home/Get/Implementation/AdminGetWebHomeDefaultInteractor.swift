import Hummingbird

struct AdminGetWebHomeDefaultInteractor: AdminGetWebHomeInteractor {
    func getHome() async throws -> AdminGetWebHomeModel {
        .init(title: "Web module")
    }
}
