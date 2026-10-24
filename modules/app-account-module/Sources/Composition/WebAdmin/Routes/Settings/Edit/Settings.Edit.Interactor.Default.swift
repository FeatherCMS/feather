import AccountModule

extension Settings.Edit.Interactor {

    struct Default:
        Settings.Edit.Interactor.Interface
    {

        let repository: any Settings.Edit.Repository.Interface

        func loadSettings() async throws -> Settings.Edit.Model {
            try await repository.loadSettings()
        }

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws {
            try await repository.saveSettings(input: input)
        }
    }
}
