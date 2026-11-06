# Feather CMS 🪶

🪶 A modern, opinionated, agentic CMS for Swift.

## Modern

Built with Swift 6.3 and later, Feather is optimized for Apple silicon and Linux servers. Structured concurrency and Swift's memory safety help keep its memory footprint and CPU usage low.

## Opinionated

Created by [Tibor Bödecs](https://x.com/tiborbodecs), a Swift Server Work Group (SSWG) member and content creator who has worked on backends since 2009. He built Feather to solve a problem of his own: Swift had no high-level backend framework, and he wanted one.

## Agentic

Agents work best with clear, consistent structure. Feather uses established patterns such as VIPER, VSA, hexagonal architecture, and onion architecture, with a clear role for every layer. Its boilerplates encode those patterns: repetitive for humans, yet useful structure for agents.

💬 Click to join the chat on [Discord](https://discord.gg/wMSkxCUXAD).


## Alpha release ⚠️

Feather is in the alpha testing phase, so features and APIs may change and
things can break between releases. The modules and `feather-core` currently
live in this main repository; they are planned to move into standalone
repositories during the beta phase.

### Feedback and contributions

We’re looking for initial feedback to help improve Feather. Share ideas and
report problems by [opening an issue](https://github.com/FeatherCMS/feather/issues),
[proposing a pull request](https://github.com/FeatherCMS/feather/pulls), or
[joining a discussion](https://github.com/FeatherCMS/feather/discussions). You
can also ask questions in our [Discord community](https://discord.gg/wMSkxCUXAD). 🙏

## Run locally

From the repository root, run the application and its required local services:

```sh
make local
```

This starts PostgreSQL and MinIO in Docker and runs the application processes
locally. Open the web app at <http://localhost:3456> and the backend at
<http://localhost:8080>. Press `Ctrl-C` to stop the local processes.

## Run with Docker

From the repository root, build and start the application and its services:

```sh
docker compose up --build
```

Open the web app at <http://localhost:3456> and the backend at
<http://localhost:8080>. Stop the containers with `Ctrl-C`, then remove them
with:

```sh
docker compose down
```

For available development commands, see [Make commands](docs/05-make-commands.md).

## Environment Configuration

See [docs/04-environment.md](docs/04-environment.md) for environment variables and executable env files.

For native Linux deployment instructions, see
[deployment/README.md](deployment/README.md).

## Feather Framework

Documentation for the underlying Feather Framework components is available at
[feather-framework.com](https://feather-framework.com).

