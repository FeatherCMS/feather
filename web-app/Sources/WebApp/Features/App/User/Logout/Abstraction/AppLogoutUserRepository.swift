import Foundation

protocol AppLogoutUserRepository: Sendable {

    func logout(
        sessionToken: String
    ) async throws
}
