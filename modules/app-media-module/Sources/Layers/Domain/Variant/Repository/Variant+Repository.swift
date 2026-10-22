public import FeatherDomain
public import MediaModule

extension Variant.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func insert(_ model: Variant.Model.New) async throws -> Variant.Model
        func update(_ model: Variant.Model) async throws -> Variant.Model
        func find(id: String) async throws -> Variant.Model?
        func list() async throws -> [Variant.Model]
        func listActive() async throws -> [Variant.Model]
        func delete(ids: [String]) async throws -> [String]
    }
}
