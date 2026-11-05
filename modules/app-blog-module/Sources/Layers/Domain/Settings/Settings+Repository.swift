public import BlogModule
public import FeatherDomain

extension Settings {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {
            func get() async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model
        }
    }
}
