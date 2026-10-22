import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import Foundation
import MediaDomain
import MediaModule
import Testing

@testable import MediaApplication

@Suite
struct VariantSearchUseCaseTestSuite {
    @Test
    func filtersAndPaginatesVariants() async throws {
        let repository = Variant.Repository.Mock(
            variants: [
                makeVariant(id: "v-1", key: "preview-small", name: "Small"),
                makeVariant(id: "v-2", key: "preview-large", name: "Large"),
                makeVariant(id: "v-3", key: "original", name: "Original"),
            ]
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Variant.Search.Scope(variantDefinitions: repository)
        )
        let useCase = Variant.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(
                query: .init(
                    page: .init(size: 1, number: 2),
                    search: "PREVIEW"
                )
            )
        )

        #expect(result.total == 2)
        #expect(result.items.map(\.id) == ["v-2"])
        #expect(await repository.listCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func doesNotSearchVariantsWhenForbidden() async throws {
        let repository = Variant.Repository.Mock(variants: [])
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Variant.Search.Scope(variantDefinitions: repository)
        )
        let useCase = Variant.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: .init(query: .init())
            )
        }

        #expect(await repository.listCallCount == 0)
        #expect(await transaction.runCallCount == 0)
    }
}

private func makeVariant(id: String, key: String, name: String) -> Variant.Model
{
    .init(
        id: id,
        key: key,
        name: name,
        isRequired: false,
        isActive: true,
        createdAt: .init(timeIntervalSince1970: 0),
        updatedAt: .init(timeIntervalSince1970: 0)
    )
}

extension Variant.Repository {
    actor Mock: Interface {
        private let variants: [Variant.Model]
        private(set) var listCallCount = 0

        init(variants: [Variant.Model]) {
            self.variants = variants
        }

        func insert(_ model: Variant.Model.New) async throws -> Variant.Model {
            throw MockError.unexpectedCall
        }

        func update(_ model: Variant.Model) async throws -> Variant.Model {
            throw MockError.unexpectedCall
        }

        func find(id: String) async throws -> Variant.Model? {
            throw MockError.unexpectedCall
        }

        func list() async throws -> [Variant.Model] {
            listCallCount += 1
            return variants
        }

        func listActive() async throws -> [Variant.Model] {
            throw MockError.unexpectedCall
        }

        func delete(ids: [String]) async throws -> [String] {
            throw MockError.unexpectedCall
        }
    }
    }

    private enum MockError: Error {
    case unexpectedCall
}
