# TODO

## Now

- [ ] Commit v1 delivery to `dev` and push (code, tests, docs, build metadata).

## Verification gates for the delivery

- [x] Build for iOS Simulator passes.
- [x] Unit tests (11) pass.
- [x] UI tests (2) pass.
- [x] Built `Info.plist` is portrait-only.
- [x] Idle-state preview matches the approved concept.
- [x] App icon matches the spec.

## Deferred (excluded by spec v1; requires a user request)

- Question input and answer history.
- Haptics, sound, or vibration.
- Physical-device verification.

## Notes

- Simulator checks do not prove physical-device behavior.
- Every file-changing delivery increments the build number once and updates
  the docs named in `AGENTS.md`.
