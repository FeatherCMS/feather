import FeatherBackend
import Foundation
import Testing

@Suite
struct HTTPErrorEnvelopeTests {

    @Test
    func encodesErrorObjectAndOmitsMissingTrace() throws {
        let envelope = HTTPErrorEnvelope(
            error: DefaultHTTPErrorContent(
                message: "Permission not found.",
                reason: "permission_not_found"
            )
        )
        let data = try JSONEncoder().encode(envelope)
        let object = try #require(
            JSONSerialization.jsonObject(with: data) as? [String: Any]
        )
        let error = try #require(object["error"] as? [String: String])

        #expect(error["message"] == "Permission not found.")
        #expect(error["reason"] == "permission_not_found")
        #expect(object["trace"] == nil)
    }

    @Test
    func encodesTraceAsSiblingToError() throws {
        let envelope = HTTPErrorEnvelope(
            error: DefaultHTTPErrorContent(
                message: "Permission not found.",
                reason: "permission_not_found"
            ),
            trace: ErrorTrace(
                type: String.self,
                logMessage: "permission lookup failed",
                children: []
            )
        )
        let data = try JSONEncoder().encode(envelope)
        let object = try #require(
            JSONSerialization.jsonObject(with: data) as? [String: Any]
        )

        #expect(object["error"] != nil)
        #expect(object["trace"] != nil)
    }
}
