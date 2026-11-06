import FeatherDatabaseTesting
import FeatherHTTP
import HTTPTypes
import MediaAdminAPI
import Testing

@Suite
struct MediaPatchHTTPTests {
    private enum QueryKey: DatabaseQueryKey {}

    @Test
    func rejectsUnknownAssetUpdateMaskField() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try MediaAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path: "/api/v1/admin/media/assets/asset-1?updateMask=unknown",
            body: Components.Schemas.MediaAssetPatchSchema()
        )

        _ = try await MediaAPIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func rejectsFolderUpdateMaskWhenSelectedNameIsMissing() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try MediaAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path: "/api/v1/admin/media/folders/folder-1?updateMask=name",
            body: Components.Schemas.MediaFolderPatchSchema(name: nil)
        )

        _ = try await MediaAPIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func rejectsVariantUpdateMaskWhenSelectedFieldIsMissing() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try MediaAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path:
                "/api/v1/admin/media/variants/variant-1?updateMask=name",
            body: Components.Schemas.MediaVariantPatchSchema()
        )

        _ = try await MediaAPIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func rejectsProcessorUpdateMaskWhenSelectedFieldIsMissing() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try MediaAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path:
                "/api/v1/admin/media/variants/variant-1/processors/processor-1?updateMask=name",
            body: Components.Schemas.MediaVariantProcessorPatchSchema()
        )

        _ = try await MediaAPIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
