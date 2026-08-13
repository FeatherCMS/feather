import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminGetWebHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetWebHomeModel
}
