# sydcheck

## Features & Comparison to similar projects

| Features                    | SydCheck  | GenValidity | Falsify  | Quickcheck | Hedgehog |
|-----------------------------|-----------|-------------|----------|------------|----------|
| Default Generator Typeclass | ✔️         | ✔️           | ✖️        | ✔️          | ✖️        |
| Free Default Generator      | ✔️         | ✔️           | ✖️        | C          | ✖️        |
| Free Default Shrinker       | ✔️         | ✔️           | ✔️        | ✖️          | ✔️        |
| Integrated Shrinking        | ✔️         | ✖️           | ✔️        | ✖️          | ✔️        |
| Internal Shrinking          | ✔️         | ✖️           | ✔️        | ✖️          | ✖️        |
| Integrated Size             | ✔️         | ✖️           | ✖️        | ✖️          | ✖️        |
| Typed counterexamples       | ✔️         | ✖️           | ✔️        | Lib        | ✖️        |
| `suchThat`/`filter`         | ✔️         | ✔️           | ✖️        | ✔️          | ✔️        |

* ✔️: Supported 
* Lib: Possible with an extra library
* C: Possible but you have to write some code yourself
* 🚧 — Under development
* ✖️: Not supported
* ?: I don't know.

Please let me know if I made a mistake anywhere, and feel free to fill in the question marks


## Migrating from genvalidity

1. Run these sed commands:

```
find . -type f -name 'package.yaml' -exec sed -i 's/genvalidity-sydtest/sydcheck-sydtest/g' {} +
find . -type f -name 'package.yaml' -exec sed -i 's/genvalidity/sydcheck/g' {} +

find . -type f -name '*.hs' -exec sed -i 's/Data.GenValidity/SydCheck/g' {} +
find . -type f -name '*.hs' -exec sed -i 's/Test.QuickCheck/SydCheck.Compatibility.QuickCheck/g' {} +
find . -type f -name '*.hs' -exec sed -i 's/Test.Syd.Validity/Test.Syd.SydCheck/g' {} +
```

2. Remove all the `shrinkValid` implementations.
