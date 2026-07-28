struct NewsletterIssueAddForm: Decodable {
    var subject: String = ""
    var content: String = ""
    var scheduledAt: String = ""
    var normalizedSubject: String {
        subject.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
