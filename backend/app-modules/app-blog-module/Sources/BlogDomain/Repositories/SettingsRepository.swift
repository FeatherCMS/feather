import Domain

public protocol SettingsRepository: Repository {
    func get() async throws -> Settings
    func update(
        _ model: Settings
    ) async throws -> Settings
}
