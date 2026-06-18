import Hummingbird

struct AdminGetMediaHomeDefaultInteractor: AdminGetMediaHomeInteractor {
    func getHome() async throws -> AdminGetMediaHomeModel {
        .init(title: "Media management")
    }
}
