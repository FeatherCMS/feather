import Testing
import MediaApplication
@testable import MediaInfrastructure

@Test("MediaInfrastructure loads")
func mediaInfrastructureLoads() {
    _ = MediaInfrastructureModule.self
}

@Test(
    "Shell runner falls back from magick to convert when magick is unavailable"
)
func shellRunnerFallsBackToConvert() {
    let runner = SubprocessMediaShellRunner()
    let result = MediaCommandResult(
        exitCode: 127,
        standardOutput: nil,
        standardError: "/bin/sh: 1: magick: not found"
    )

    let fallback = runner.fallbackCommand(
        for: "magick /tmp/input.png -resize 320x320 /tmp/output.png",
        result: result
    )

    #expect(
        fallback == "convert /tmp/input.png -resize 320x320 /tmp/output.png"
    )
}
