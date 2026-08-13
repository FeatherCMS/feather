import FeatherDomain

public protocol CampaignRepository: Repository {

    func list() async throws -> [Campaign]

    func findBy(
        id: String
    ) async throws -> Campaign?

    func insert(
        _ model: Campaign.New
    ) async throws -> Campaign

    func update(
        _ model: Campaign
    ) async throws -> Campaign

    func delete(
        id: String
    ) async throws -> Bool
}
