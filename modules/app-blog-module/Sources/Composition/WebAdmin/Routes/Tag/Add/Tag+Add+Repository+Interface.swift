import BlogModule
import FeatherValidation

extension Tag.Add.Repository {
    protocol Interface: Sendable {
        func create(input: Tag.Form.Input) async throws
    }
}
