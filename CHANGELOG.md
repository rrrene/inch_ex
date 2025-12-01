# Changelog

## 2.1.0

- Require Elixir `>= 1.15.0` (the goal is to support the last 5 minor Elixir releases)
- Fix lots of bugs in newer versions of Elixir
- Support macro docs, generated docs, delegated docs, type docs and numeric function names
- Make `explain` also take the name as first argument
- Add grade distribution to JSON output
- Improve fallback role message for explain
- Ignore files without docs chunk present (thx @LostKobrakai)

## 2.0.0

- Make use of Elixir's adoption of EEP 48
- Require Elixir `>= 1.7.0`
- This is not backwards compatible to InchEx v1!
