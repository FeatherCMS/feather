import FeatherWebAdmin
import Foundation
import Testing

@Suite
struct AdminDateFormatterTests {
    @Test
    func formatsDatesAndTimesAccordingToConfiguredLocale() {
        let date = Date(timeIntervalSince1970: 47_100)
        let usFormatter = AdminDateFormatter(
            language: "en-US",
            timezone: "UTC"
        )
        let ukFormatter = AdminDateFormatter(
            language: "en-GB",
            timezone: "UTC"
        )

        #expect(usFormatter.formatTime(date).contains("1:05"))
        #expect(usFormatter.formatTime(date).contains("PM"))
        #expect(ukFormatter.formatTime(date).contains("13:05"))
        #expect(usFormatter.formatDate(date).hasPrefix("Jan"))
        #expect(ukFormatter.formatDate(date).hasPrefix("1"))
    }
}
