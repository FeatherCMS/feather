import FeatherDomain

public protocol AccountProfileRepository: Repository {

    func get(userId: String) async throws -> AccountProfile

    func getOrCreate(userId: String) async throws -> AccountProfile

    func create(userId: String) async throws

    func update(_ model: AccountProfile) async throws -> AccountProfile

    func delete(userId: String) async throws
}
