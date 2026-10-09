let renderModules
    : List Text -> Text
    = \(modules : List Text) ->
        ( List/fold
            Text
            modules
            { acc : Text, first : Bool }
            ( \(m : Text) ->
              \(st : { acc : Text, first : Bool }) ->
                if    st.first
                then  { acc = m, first = False }
                else  { acc = "${m}, ${st.acc}", first = False }
            )
            { acc = "", first = True }
        ).acc

let renderDeps
    : List Text -> Text
    = \(deps : List Text) ->
        if    Natural/isZero (List/length Text deps)
        then  ""
        else  "  build-depends:\n${List/fold Text deps Text (\(d : Text) -> \(acc : Text) -> "    , ${d}\n${acc}") ""}"

let sharedStanza =
      ''

      common shared -- {{{
        mixins:
          , base hiding (Prelude)
          , base-prelude (BasePrelude as Prelude)
        build-depends: base, base-prelude
        ghc-options: -O2
        default-language: GHC2024
        default-extensions:
          , BlockArguments
          , CPP
          , DerivingVia
          , MultiWayIf
          , RecordWildCards
          , ViewPatterns
      -- }}}
      ''

let Library = { srcDir : Text, modules : List Text, deps : List Text }
let Exe = { srcDir : Text, mainIs : Text, deps : List Text }

let library
    : Library -> Text
    = \(cfg : Library) ->
        "\nlibrary\n  import: shared\n  hs-source-dirs: ${cfg.srcDir}\n  exposed-modules: ${renderModules cfg.modules}\n${renderDeps cfg.deps}"

let executable
    : Text -> Exe -> Text
    = \(name : Text) ->
      \(cfg : Exe) ->
        "\nexecutable ${name}\n  import: shared\n  hs-source-dirs: ${cfg.srcDir}\n  main-is: ${cfg.mainIs}\n${renderDeps cfg.deps}"

let testSuite
    : Text -> Exe -> Text
    = \(name : Text) ->
      \(cfg : Exe) ->
        "\ntest-suite ${name}\n  import: shared\n  type: exitcode-stdio-1.0\n  hs-source-dirs: ${cfg.srcDir}\n  main-is: ${cfg.mainIs}\n${renderDeps cfg.deps}"

let package
    : Text -> List Text -> Text
    = \(name : Text) ->
      \(components : List Text) ->
        "cabal-version: 3.0\nname: ${name}\nversion: 0.1.0.0\n${sharedStanza}${List/fold Text components Text (\(c : Text) -> \(acc : Text) -> "${c}${acc}") ""}"

in  { package, library, executable, testSuite }
