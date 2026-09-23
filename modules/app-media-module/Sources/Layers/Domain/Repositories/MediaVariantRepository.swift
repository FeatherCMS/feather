public import FeatherDomain

public protocol MediaVariantRepository: Repository {
    func insert(_ model: MediaVariant.New) async throws -> MediaVariant
    func update(_ model: MediaVariant) async throws -> MediaVariant
    func find(id: String) async throws -> MediaVariant?
    func list() async throws -> [MediaVariant]
    func listActive() async throws -> [MediaVariant]
    func delete(ids: [String]) async throws -> [String]
}
