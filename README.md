# Evergreen Homebrew tap

Homebrew formulae for [Evergreen](https://github.com/arminazimi/evergreen), the local-first lifecycle intelligence CLI.

## Install

```sh
brew install arminazimi/tap/evergreen
```

Homebrew installs Node.js and keeps Evergreen's npm dependencies inside its own prefix. It does not install npm packages globally for the user.

On Homebrew versions that require explicit tap trust, trust just this formula:

```sh
brew tap arminazimi/tap
brew trust --formula arminazimi/tap/evergreen
brew install arminazimi/tap/evergreen
```

## Use

```sh
evergreen --version
evergreen scan /path/to/repository
```

The formula also provides `evergreen-deprecation` and `evergreen-mcp`. Scans read local files and bundled lifecycle data; they require no network access.

## Validate a formula change

```sh
brew style arminazimi/tap/evergreen
brew install --build-from-source arminazimi/tap/evergreen
brew test arminazimi/tap/evergreen
```

The functional test verifies that the installed package reports a deprecated dependency and finds its JavaScript source usage. CI runs on macOS and Linux.

## Update

For a new upstream release, update the npm tarball URL and SHA-256 in `Formula/evergreen.rb`, then run the checks above and open a pull request. Keep the source pinned to an exact published version.
