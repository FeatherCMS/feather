import BlogModule
import FeatherValidation

extension Tag.Add.Interactor {
    protocol Interface: Sendable {
        func execute(input: Tag.Form.Input) async throws
    }
}
