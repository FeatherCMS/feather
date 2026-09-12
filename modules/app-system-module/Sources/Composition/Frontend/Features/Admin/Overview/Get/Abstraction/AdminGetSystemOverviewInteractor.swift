import FeatherAdmin
import Hummingbird

protocol AdminGetSystemOverviewInteractor: Sendable {

    func getHome() async throws -> AdminGetSystemOverviewModel
}
