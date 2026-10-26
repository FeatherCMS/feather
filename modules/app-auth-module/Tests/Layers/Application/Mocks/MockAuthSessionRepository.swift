import AuthDomain
import AuthModule

import struct Foundation.Date

actor MockAuthSessionRepository: Session.Repository.Interface {
    private let result: Session.Model?

    init(result: Session.Model? = nil) {
        self.result = result
    }

    func findBy(id: String) async throws -> Session.Model? { result }
    func findBy(token: String) async throws -> Session.Model? { nil }
    func insert(_ model: Session.Model.New) async throws
        -> Session.Model
    {
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
    func update(_ model: Session.Model) async throws
        -> Session.Model
    { model }
    func delete(ids: [String]) async throws -> [String] { [] }
}
