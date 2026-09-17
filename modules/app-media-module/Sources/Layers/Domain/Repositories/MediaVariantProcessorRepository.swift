import FeatherDomain

public protocol MediaVariantProcessorRepository: Repository {
    func insert(_ model: MediaVariantProcessor.New) async throws -> MediaVariantProcessor
    func update(_ model: MediaVariantProcessor) async throws -> MediaVariantProcessor
    func find(id: String) async throws -> MediaVariantProcessor?
    func list(variantId: String) async throws -> [MediaVariantProcessor]
    func listActive() async throws -> [MediaVariantProcessor]
    func delete(ids: [String]) async throws -> [String]
}
