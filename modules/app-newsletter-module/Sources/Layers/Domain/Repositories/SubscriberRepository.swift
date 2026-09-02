import FeatherDomain

public protocol SubscriberRepository: Repository {

    func list(
        newsletterId: String
    ) async throws -> [Subscriber]

    func findBy(
        newsletterId: String,
        email: String
    ) async throws -> Subscriber?

    func insert(
        _ model: Subscriber.New
    ) async throws -> Subscriber

    func update(
        _ model: Subscriber
    ) async throws -> Subscriber

    func delete(
        newsletterId: String,
        emails: [String]
    ) async throws -> [String]
}
