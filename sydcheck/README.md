# sydcheck

## Features & Comparison to similar projects

| Features                    | SydCheck  | GenValidity | Falsify  | Quickcheck | Hedgehog |
|-----------------------------|-----------|-------------|----------|------------|----------|
| Default Generator Typeclass | ✔️         | ✔️           | ✖️        | ✔️          | ✖️        |
| Free Default Generator      | ✔️         | ✔️           | ✖️        | C          | ✖️        |
| Free Shrinking              | ✔️         | ✔️           | ✔️        | ✖️          | ✔️        |
| Integrated Shrinking        | ✔️         | ✖️           | ✔️        | ✖️          | ✔️        |
| Internal Shrinking          | ✔️         | ✖️           | ✔️        | ✖️          | ✖️        |
| Integrated Size             | ✔️         | ✖️           | ✖️        | ✖️          | ✖️        |
| Typed counterexamples       | ✔️         | ✖️           | ✔️        | ✖️          | ✖️        |
| `suchThat`/`filter`         | ✔️         | ✔️           | ✖️        | ✔️          | ✔️        |

* ✔️: Supported 
* Lib: Possible with an extra library
* C: Possible but you have to write some code yourself
* 🚧 — Under development
* ✖️: Not supported
* ?: I don't know.

Please let me know if I made a mistake anywhere, and feel free to fill in the question marks

