public import AccountModule
public import FeatherDomain

extension Profile {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func get(userId: String) async throws -> Model

            func getOrCreate(userId: String) async throws
                -> Model

            func create(userId: String) async throws

            func update(_ model: Model) async throws
                -> Model

            func delete(userId: String) async throws
        }
    }
}
