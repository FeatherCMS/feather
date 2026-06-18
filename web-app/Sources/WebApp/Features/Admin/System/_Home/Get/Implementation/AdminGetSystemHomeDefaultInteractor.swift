import Hummingbird

struct AdminGetSystemHomeDefaultInteractor: AdminGetSystemHomeInteractor {
    func getHome() async throws -> AdminGetSystemHomeModel {
        .init(title: "System module")
    }
}
