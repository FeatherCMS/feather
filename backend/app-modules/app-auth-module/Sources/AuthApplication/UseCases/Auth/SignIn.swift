import Domain
import AuthDomain
import Application
import UserDomain
import struct Foundation.Date

protocol SignIn: UseCase {

    func makeAuthResponse(
        clock: any Clock,
        idGenerator: any IDGenerator,
        userAccountRepository: any AccountRepository,
        userSessionRepository: any SessionRepository,
        user: Account,
        isPersistent: Bool
    ) async throws -> AuthDetail

}

extension SignIn {

    func makeAuthResponse(
        clock: any Clock,
        idGenerator: any IDGenerator,
        userAccountRepository: any AccountRepository,
        userSessionRepository: any SessionRepository,
        user: Account,
        isPersistent: Bool
    ) async throws -> AuthDetail {
        let accountId = user.id

        let (roles, permissions) = try await (
            userAccountRepository.findRolesBy(
                accountId: accountId
            ),
            userAccountRepository.findPermissionsBy(
                accountId: accountId
            )
        )

        let sessionLifetime =
            isPersistent
            ? Session.Lifetimes.persistent : Session.Lifetimes.regular

        let session = try await userSessionRepository.insert(
            Session.create(
                id: idGenerator.generate(),
                token: generateToken(),
                accountId: accountId,
                expiresAtInterval: sessionLifetime,
                isPersistent: isPersistent
            )
        )

        return .init(
            user: user,
            session: session,
            roles: roles,
            permissions: permissions
        )
    }
}
