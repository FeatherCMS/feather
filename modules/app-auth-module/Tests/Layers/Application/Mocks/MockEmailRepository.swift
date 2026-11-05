import AuthDomain
import AuthModule
import Foundation

actor MockAuthEmailRepository: Email.Repository.Interface {
    private let result: Email.Model?

    init(result: Email.Model? = nil) {
        self.result = result
    }

    func list() async throws -> [Email.Model] {
        result.map { [$0] } ?? []
    }

    func findBy(id: String) async throws -> Email.Model? {
        result?.id == id ? result : nil
    }

    func findBy(email: String) async throws -> Email.Model? {
        result?.email == email ? result : nil
    }

    func findBy(identityId: String) async throws -> Email.Model? {
        result?.identityId == identityId ? result : nil
    }

    func insert(
        identityId: String,
        email: String
    ) async throws -> Email.Model {
        .init(
            id: "auth-email-1",
            identityId: identityId,
            email: email,
            createdAt: .init(),
            updatedAt: .init()
        )
    }

    func update(
        _ model: Email.Model
    ) async throws -> Email.Model {
        model
    }

    func delete(ids: [String]) async throws -> [String] {
        ids
    }
}
