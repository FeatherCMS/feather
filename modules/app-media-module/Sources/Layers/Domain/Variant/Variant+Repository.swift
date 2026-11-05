public import FeatherDomain
public import MediaModule

extension Variant {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func insert(_ model: Model.New) async throws -> Model
            func update(_ model: Model) async throws -> Model
            func find(id: String) async throws -> Model?
            func list() async throws -> [Model]
            func listActive() async throws -> [Model]
            func delete(ids: [String]) async throws -> [String]
        }
    }
}
