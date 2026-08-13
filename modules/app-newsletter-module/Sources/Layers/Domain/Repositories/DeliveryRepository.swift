import FeatherDomain

public protocol DeliveryRepository: Repository {

    func list(
        issueId: String
    ) async throws -> [Delivery]

    func findBy(
        issueId: String,
        subscriberEmail: String
    ) async throws -> Delivery?

    func insert(
        _ model: Delivery.New
    ) async throws -> Delivery

    func update(
        _ model: Delivery
    ) async throws -> Delivery
}
