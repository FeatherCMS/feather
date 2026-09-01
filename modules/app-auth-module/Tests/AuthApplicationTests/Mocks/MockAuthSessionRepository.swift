import AuthDomain

import struct Foundation.Date

actor MockAuthSessionRepository: SessionRepository {
    private let result: Session?

    init(result: Session? = nil) {
        self.result = result
    }

    func findBy(id: String) async throws -> Session? { result }
    func findBy(token: String) async throws -> Session? { nil }
    func insert(_ model: Session.New) async throws -> Session {
        .init(
            id: "session-magic-link",
            token: model.token,
            identityId: model.identityId,
            authenticationType: model.authenticationType,
            authenticationReference: model.authenticationReference,
            expiresAt: Date().addingTimeInterval(model.expiresAtInterval)
                .timeIntervalSince1970,
            isPersistent: model.isPersistent,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    func update(_ model: Session) async throws -> Session { model }
    func delete(id: String) async throws -> Bool { false }
}
