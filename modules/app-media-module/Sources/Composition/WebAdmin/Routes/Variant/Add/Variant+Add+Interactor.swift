import MediaModule

extension Variant.Add.Interactor {
    protocol Interface: Sendable {
        func add(input: MediaVariantFormInput) async throws
    }
}
