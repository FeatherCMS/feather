import Foundation
import NewsletterDomain
import NewsletterModule

actor CampaignRepositoryMock: Campaign.Repository.Interface {
    private var model: Campaign.Model

    init(model: Campaign.Model) {
        self.model = model
    }

    func findBy(id: String) async throws -> Campaign.Model? {
        model.id == id ? model : nil
    }

    func findBy(key: String) async throws -> Campaign.Model? {
        model.key == key ? model : nil
    }

    func insert(_ value: Campaign.Model.New) async throws -> Campaign.Model {
        let date = Date()
        model = .init(
            id: "campaign-created",
            key: value.key,
            name: value.name,
            fromEmail: value.fromEmail,
            createdAt: date,
            updatedAt: date
        )
        return model
    }

    func update(_ value: Campaign.Model) async throws -> Campaign.Model {
        model = value
        return model
    }

    func delete(ids: [String]) async throws -> [String] {
        ids
    }
}
