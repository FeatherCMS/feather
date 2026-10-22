import BlogModule
import FeatherValidation

extension Tag.Add {
    enum Repository {}
}

extension Tag.Add.Repository {
    protocol Interface: Sendable {
        func create(input: BlogTagFormInput) async throws
    }
}
