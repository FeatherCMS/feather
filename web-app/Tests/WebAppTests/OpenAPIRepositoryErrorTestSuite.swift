import Testing

@testable import WebApp

@Suite
struct OpenAPIRepositoryErrorTestSuite {

    @Test
    func parsesStructuredBackendFailure() {
        let error = OpenAPIRepositoryError.parsedFailure(
            statusCode: 503,
            responseBody: """
                {
                  "code": 503,
                  "message": "Internal server error.",
                  "reason": "Random failure.",
                  "requestPath": "/api/v1/admin/web/pages/search",
                  "operationID": "webPageSearch",
                  "trace": {
                    "id": "ServerError",
                    "message": "Root",
                    "reasons": [
                      {
                        "id": "DatabaseError",
                        "message": "Connection lost"
                      }
                    ]
                  }
                }
                """
        )

        #expect(error.displayTitle == "Unexpected response from server (503).")
        #expect(
            error.displayMessage.contains(
                "Status: 503"
            )
        )
        #expect(
            error.displayMessage.contains(
                "Message: Internal server error."
            )
        )
        #expect(
            error.displayMessage.contains(
                "Reason: Random failure."
            )
        )
        #expect(
            error.displayMessage.contains(
                "Operation ID: webPageSearch"
            )
        )
        #expect(
            error.displayMessage.contains(
                "Request path: /api/v1/admin/web/pages/search"
            )
        )
        #expect(
            error.displayMessage.contains(
                "ServerError: \"Root\""
            )
        )
        #expect(
            error.displayMessage.contains(
                "DatabaseError: \"Connection lost\""
            )
        )
    }

    @Test
    func fallsBackToRawResponseBody() {
        let error = OpenAPIRepositoryError.parsedFailure(
            statusCode: 500,
            responseBody: "plain failure body"
        )

        #expect(
            error.displayMessage == """
                Status: 500
                Response body: plain failure body
                """
        )
    }

    @Test
    func rendersEmptyFallbackFailure() {
        let error = OpenAPIRepositoryError.parsedFailure(
            statusCode: 500,
            responseBody: nil
        )

        #expect(
            error.displayMessage == """
                Status: 500
                Response body: <empty>
                """
        )
    }

    @Test
    func rendersTransportMessageWithoutLocalizedDescription() {
        let error = OpenAPIRepositoryError.transport(
            description: "connect timeout"
        )

        #expect(
            error.displayMessage == """
                Transport request failed.
                Details: connect timeout
                """
        )
    }
}
