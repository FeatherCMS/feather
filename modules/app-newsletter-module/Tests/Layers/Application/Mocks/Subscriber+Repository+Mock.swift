import Foundation
import NewsletterDomain
import NewsletterModule

actor SubscriberRepositoryMock: Subscriber.Repository.Interface {
    private var storedModel: Subscriber.Model?

    init(model: Subscriber.Model? = nil) {
        storedModel = model
    }

    func current() -> Subscriber.Model? {
        storedModel
    }

    func list(newsletterId: String) async throws -> [Subscriber.Model] {
        guard let storedModel, storedModel.newsletterId == newsletterId else {
            return []
        }
        return [storedModel]
    }

    func findBy(
        newsletterId: String,
        email: String
    ) async throws -> Subscriber.Model? {
        guard
            let storedModel,
            storedModel.newsletterId == newsletterId,
            storedModel.email.caseInsensitiveCompare(email) == .orderedSame
        else {
            return nil
        }
        return storedModel
    }

    func findBy(
        newsletterId: String,
        unsubscribeToken: String
    ) async throws -> Subscriber.Model? {
        guard
            let storedModel,
            storedModel.newsletterId == newsletterId,
            storedModel.unsubscribeToken == unsubscribeToken
        else {
            return nil
        }
        return storedModel
    }

    func insert(_ value: Subscriber.Model.New) async throws -> Subscriber.Model
    {
        storedModel = .init(
            newsletterId: value.newsletterId,
            email: value.email,
            status: value.status,
            subscriptionDate: value.subscriptionDate,
            unsubscriptionDate: value.unsubscriptionDate,
            firstName: value.firstName,
            lastName: value.lastName,
            confirmedAt: value.confirmedAt,
            unsubscribeToken: value.unsubscribeToken,
            source: value.source,
            lastSentAt: value.lastSentAt,
            createdAt: value.subscriptionDate,
            updatedAt: value.subscriptionDate
        )
        return storedModel!
    }

    func update(_ value: Subscriber.Model) async throws -> Subscriber.Model {
        storedModel = value
        return value
    }

    func delete(
        newsletterId: String,
        emails: [String]
    ) async throws -> [String] {
        guard
            let storedModel,
            storedModel.newsletterId == newsletterId,
            emails.contains(storedModel.email)
        else {
            return []
        }
        self.storedModel = nil
        return [storedModel.email]
    }
}
