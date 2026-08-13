import FeatherHTTP
import HTTPTypes
import Logging
import OpenAPIRuntime
import Testing

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@testable import Server

@Suite
struct ServerTestSuite {

    @Test
    func health() async throws {
        let runner = try await TestRunner()

        //        try await runner.setupMigratedDatabase()
        print(runner.system.name)

        try await runner.run(
            request: Request(
                method: .get,
                path: "/health"
            )
        ) { response in
            #expect(response.status == .ok)
        }
    }
}
