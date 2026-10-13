import AuthDomain
import Foundation

@testable import AuthDomain

actor MockAuthEmailRepository: AuthEmailRepository {
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var insertedEmails: [String] = []
    private var emails: [AuthEmail] = []

    func emailCount() -> Int {
        emails.count
    }

    func list() async throws -> [AuthEmail] {
        emails
    }

    func findBy(id: String) async throws -> AuthEmail? {
        emails.first { $0.id == id }
    }

    func findBy(email: String) async throws -> AuthEmail? {
        emails.first { $0.email == email }
    }

    func insert(
        identityId: String,
        email: String
    ) async throws -> AuthEmail {
        insertCallCount += 1
        insertedEmails.append(email)
        let model = AuthEmail(
            id: "auth-email-\(insertCallCount)",
            identityId: identityId,
            email: email,
            createdAt: Date(),
            updatedAt: Date()
        )
        emails.append(model)
        return model
    }

    func update(_ model: AuthEmail) async throws -> AuthEmail {
        if let index = emails.firstIndex(where: { $0.id == model.id }) {
            emails[index] = model
        }
        return model
    }

    func delete(ids: [String]) async throws -> [String] {
        deleteCallCount += 1
        let removed = emails.filter { ids.contains($0.id) }.map(\.id)
        emails.removeAll { ids.contains($0.id) }
        return removed
    }
}
