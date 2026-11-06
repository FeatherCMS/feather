public import AuthModule
public import FeatherDomain

extension Email {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func list() async throws -> [Model]
            func findBy(id: String) async throws -> Model?
            func findBy(email: String) async throws -> Model?
            func findBy(identityId: String) async throws -> Model?
            func insert(identityId: String, email: String) async throws
                -> Model
            func update(_ model: Model) async throws
                -> Model
            func delete(ids: [String]) async throws -> [String]
        }
    }
}
