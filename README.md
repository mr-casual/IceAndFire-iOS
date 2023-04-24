# IceAndFire-iOS

[![CI Build](https://github.com/mr-casual/IceAndFire-iOS/actions/workflows/run_tests.yml/badge.svg)](https://github.com/irongut/CodeCoverageSummary/actions/workflows/ci-build.yml)
[![Code Coverage 82%](https://img.shields.io/badge/Code%20Coverage-82%25-success?style=flat)](https://github.com/mr-casual/IceAndFire-iOS)

Coding challenge for OneCode

## The Challenge
- [german](doc/Challenge-de.md)
- [english](doc/Challenge-en.md)

## About
It's a simple iOS app which uses the following tech stack:
- SwiftUI
- MVVM
- async/await
- Combine

#### Note
The inital idea was to use `TaskGroups` to load the content for the detail screen.
But I ended up using Combine, because it's easier when it comes to values of different types. The child task of a group must be of the same type.

#### Possible Features and Improvements

- also show details of characters
- optimize layout for smaller devices
- optimize for iPad
- fix code coverage report
- generated shield for code coverage
- load images from different source
- make UI more fancy ;)

