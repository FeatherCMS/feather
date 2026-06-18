protocol AdminEditBlogSettingsRepository: Sendable {
    func loadSettings() async throws -> AdminEditBlogSettingsModel
    func saveSettings(
        input: AdminEditBlogSettingsFormInput
    ) async throws
}
