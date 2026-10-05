public protocol ContactJobs: Sendable {
    func enqueueSubmissionMail(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: [String],
        messageBody: String
    ) async throws
}
