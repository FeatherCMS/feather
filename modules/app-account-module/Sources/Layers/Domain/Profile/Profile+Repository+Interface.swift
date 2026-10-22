public import AccountModule
public import FeatherDomain

extension Profile {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func get(userId: String) async throws -> Profile.Model

            func getOrCreate(userId: String) async throws
                -> Profile.Model

            func create(userId: String) async throws

            func update(_ model: Profile.Model) async throws
                -> Profile.Model

            func delete(userId: String) async throws
        }
    }
}
