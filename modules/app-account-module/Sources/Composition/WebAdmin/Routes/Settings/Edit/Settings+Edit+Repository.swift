import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit {
    enum Repository {}
}

extension Settings.Edit.Repository {

    protocol Interface: Sendable {

        func loadSettings() async throws -> Settings.Edit.Model

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws
    }
}
