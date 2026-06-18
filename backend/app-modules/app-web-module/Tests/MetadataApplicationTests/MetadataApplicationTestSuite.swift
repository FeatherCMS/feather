import Testing
import Application
import Domain
import struct Foundation.Date
import WebDomain
@testable import WebApplication

@Suite
struct MetadataApplicationTestSuite {

    @Test
    func metadataDirectAccessAllowsDraftButNotArchived() {
        let now = Date()

        let draft = MetadataDetail(
            referenceType: "web.page",
            referenceID: "draft-1",
            id: "draft-1",
            slug: "draft-page",
            publicationDate: nil,
            expirationDate: nil,
            status: .draft,
            title: nil,
            excerpt: nil,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: now,
            updatedAt: now
        )
        let archived = MetadataDetail(
            referenceType: "web.page",
            referenceID: "archived-1",
            id: "archived-1",
            slug: "archived-page",
            publicationDate: now.addingTimeInterval(-60),
            expirationDate: nil,
            status: .archived,
            title: nil,
            excerpt: nil,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: now,
            updatedAt: now
        )

        #expect(draft.isDirectlyAccessible(at: now))
        #expect(!archived.isDirectlyAccessible(at: now))
    }

    @Test
    func addEntrySuccess() async throws {
        let repository = EntryMockRepository(
            result: .success(makeEntry(id: "v-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WriteMetadata(metadata: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddMetadata(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: AddMetadata.Input(
                source: "/old-path",
                destination: "/new-path",
                statusCode: 301,
                notes: "permanent metadata"
            )
        )

        let createInput = await repository.lastCreateInput

        #expect(result.id == "v-1")
        #expect(createInput?.id == "generated-id")
        #expect(createInput?.source == "/old-path")
        #expect(createInput?.destination == "/new-path")
        #expect(createInput?.statusCode == 301)
        #expect(createInput?.notes == "permanent metadata")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
        #expect(await repository.createCallCount == 1)
    }

    @Test
    func addEntryForbidden() async throws {
        let repository = EntryMockRepository(
            result: .success(makeEntry(id: "v-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WriteMetadata(metadata: repository)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = AddMetadata(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: AddMetadata.Input(
                    source: "/old-path",
                    destination: "/new-path",
                    statusCode: 302,
                    notes: "temporary metadata"
                )
            )
        }
        #expect(await transaction.runCallCount == 0)
        #expect(await repository.createCallCount == 0)
    }

    @Test
    func getEntrySuccess() async throws {
        let queries = EntryMockQueries(
            findResult: makeEntryDetail(id: "v-1"),
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadMetadata(metadata: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = GetMetadata(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: GetMetadata.Input(id: "v-1")
        )

        #expect(result.id == "v-1")
        #expect(result.source == "/source-v-1")
        #expect(await queries.findCallCount == 1)
        #expect(await queries.lastFindId == "v-1")
    }

    @Test
    func listEntriesAndCountSuccess() async throws {
        let listQuery = MetadataList.Query(
            page: .init(size: 10, number: 2),
            sort: [.init(field: .source, direction: .asc)],
            search: "needle"
        )
        let queries = EntryMockQueries(
            findResult: makeEntryDetail(id: "v-2"),
            listResult: .init(items: [makeEntryListItem(id: "v-2")]),
            countResult: 42
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadMetadata(metadata: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListMetadata(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: ListMetadata.Input(query: listQuery)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-2"),
            input: ListMetadata.Input(query: listQuery)
        )

        #expect(list.items.count == 1)
        #expect(list.items.first?.destination == "/destination-v-2")
        #expect(count == 42)
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func editEntrySuccess() async throws {
        let repository = EntryMockRepository(
            result: .success(makeEntry(id: "v-3")),
            findResult: makeEntry(id: "v-3")
        )
        let transaction = MockTransactionExecutor(
            context: WriteMetadata(metadata: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = EditMetadata(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-3"),
            input: EditMetadata.Input(
                id: "v-3",
                source: "/updated-source",
                destination: "/updated-destination",
                statusCode: 308,
                notes: "updated notes"
            )
        )

        #expect(result.id == "v-3")
        #expect(result.source == "/updated-source")
        #expect(result.destination == "/updated-destination")
        #expect(result.statusCode == 308)
        #expect(await repository.findCallCount == 1)
        #expect(await repository.updateCallCount == 1)
    }

    @Test
    func removeEntryForbidden() async throws {
        let repository = EntryMockRepository(
            result: .success(makeEntry(id: "v-4")),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteMetadata(metadata: repository)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RemoveMetadata(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-4"),
                input: RemoveMetadata.Input(id: "v-4")
            )
        }
        #expect(await repository.deleteCallCount == 0)
    }

    @Test
    func removeEntrySuccess() async throws {
        let repository = EntryMockRepository(
            result: .success(makeEntry(id: "v-5")),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteMetadata(metadata: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RemoveMetadata(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: RemoveMetadata.Input(id: "v-5")
        )

        #expect(deleted)
        #expect(await repository.deleteCallCount == 1)
        #expect(await repository.lastDeleteId == "v-5")
    }
}

private func makeEntry(
    id: String
) -> Metadata {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: 302,
        notes: "valid-notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeEntryDetail(
    id: String
) -> MetadataDetail {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: 301,
        notes: "valid-notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeEntryListItem(
    id: String
) -> MetadataList.Item {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: 307,
        notes: "notes-\(id)",
        createdAt: Date(),
        updatedAt: Date()
    )
}
