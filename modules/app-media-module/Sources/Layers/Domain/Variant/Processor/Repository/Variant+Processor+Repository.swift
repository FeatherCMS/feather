public import FeatherDomain
public import MediaModule

extension Variant.Processor.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func insert(_ model: Variant.Processor.Model.New) async throws
            -> Variant.Processor.Model
        func update(_ model: Variant.Processor.Model) async throws
            -> Variant.Processor.Model
        func find(id: String) async throws -> Variant.Processor.Model?
        func list(variantId: String) async throws -> [Variant.Processor.Model]
        func listActive() async throws -> [Variant.Processor.Model]
        func delete(ids: [String]) async throws -> [String]
    }
}
