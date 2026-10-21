import AuthDomain
import AuthModule
import Foundation

actor MockAuthEmailRepository: AuthEmail.Repository.Interface {
    private let result: AuthEmail.Model?

    init(result: AuthEmail.Model? = nil) {
        self.result = result
    }

    func list() async throws -> [AuthEmail.Model] {
        result.map { [$0] } ?? []
    }

    func findBy(id: String) async throws -> AuthEmail.Model? {
        result?.id == id ? result : nil
    }

    func findBy(email: String) async throws -> AuthEmail.Model? {
        result?.email == email ? result : nil
    }

    func findBy(identityId: String) async throws -> AuthEmail.Model? {
        result?.identityId == identityId ? result : nil
    }

    func insert(
        identityId: String,
        email: String
    ) async throws -> AuthEmail.Model {
        .init(
            id: "auth-email-1",
            identityId: identityId,
            email: email,
            createdAt: .init(),
            updatedAt: .init()
        )
    }

    func update(
        _ model: AuthEmail.Model
    ) async throws -> AuthEmail.Model {
        model
    }

    func delete(ids: [String]) async throws -> [String] {
        ids
    }
}
