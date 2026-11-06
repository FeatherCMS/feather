public import FeatherDomain
public import RedirectModule

extension Rule {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func insert(_ model: Model.New) async throws -> Model
            func update(_ model: Model) async throws -> Model
            func find(id: String) async throws -> Model?
            func find(source: String) async throws -> Model?
            func delete(ids: [String]) async throws -> [String]
        }
    }
}
