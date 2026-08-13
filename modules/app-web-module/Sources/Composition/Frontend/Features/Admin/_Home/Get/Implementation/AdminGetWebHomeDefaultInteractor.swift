import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminGetWebHomeDefaultInteractor: AdminGetWebHomeInteractor {
    func getHome() async throws -> AdminGetWebHomeModel {
        .init(title: "Web module")
    }
}
