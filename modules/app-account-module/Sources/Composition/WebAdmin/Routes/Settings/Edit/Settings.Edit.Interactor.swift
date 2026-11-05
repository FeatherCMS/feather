import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit {
    enum Interactor {}
}

extension Settings.Edit.Interactor {

    protocol Interface: Sendable {

        func loadSettings() async throws -> Settings.Edit.Model

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws
    }
}
