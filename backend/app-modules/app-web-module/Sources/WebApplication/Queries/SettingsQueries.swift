public protocol SettingsQueries: Sendable {

    func get() async throws -> SettingsDetail
}
