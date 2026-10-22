import AuthDomain
import AuthModule
import Foundation

@testable import AuthDomain

actor MockAuthEmailRepository: Email.Repository.Interface {
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var insertedEmails: [String] = []
    private var emails: [Email.Model] = []

    func emailCount() -> Int {
        emails.count
    }

    func list() async throws -> [Email.Model] {
        emails
    }

    func findBy(id: String) async throws -> Email.Model? {
        emails.first { $0.id == id }
    }

    func findBy(email: String) async throws -> Email.Model? {
        emails.first { $0.email == email }
    }

    func findBy(identityId: String) async throws -> Email.Model? {
        emails.first { $0.identityId == identityId }
    }

    func insert(
        identityId: String,
        email: String
    ) async throws -> Email.Model {
        insertCallCount += 1
        insertedEmails.append(email)
        let model = Email.Model(
            id: "auth-email-\(insertCallCount)",
            identityId: identityId,
            email: email,
            createdAt: Date(),
            updatedAt: Date()
        )
        emails.append(model)
        return model
    }

    func update(_ model: Email.Model) async throws -> Email.Model {
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
