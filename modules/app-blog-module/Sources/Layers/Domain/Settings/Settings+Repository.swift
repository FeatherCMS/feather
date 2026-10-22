public import BlogModule
public import FeatherDomain

extension Settings.Repository {
    public protocol Interface: FeatherDomain.Repository {
        func get() async throws -> Settings.Model

        func update(
            _ model: Settings.Model
        ) async throws -> Settings.Model
    }
}
