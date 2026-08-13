import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminGetRedirectHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetRedirectHomeModel
}
