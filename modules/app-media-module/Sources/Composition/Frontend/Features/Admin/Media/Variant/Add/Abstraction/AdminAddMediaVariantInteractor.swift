import Foundation

protocol AdminAddMediaVariantInteractor: Sendable {
    func add(input: MediaVariantFormInput) async throws
}
