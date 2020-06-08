let Prelude = ../External/Prelude.dhall
let List/map = Prelude.List.map
let B = ../External/Buildkite.dhall
let B/Plugins/Partial = B.definitions/commandStep/properties/plugins/Type
let Map = Prelude.Map

let Decorate = ../Lib/Decorate.dhall

let Docker = ./Docker/Type.dhall
let Summon = ./Summon/Type.dhall
let Base = ./Base.dhall

let Size = ./Size.dhall

let fixPermissionsCommand = "sudo chown -R opam ."

let Config = {
  Type = {
    commands : List Text,
    label : Text,
    key : Text
  },
  default = {=}
}


let build : Config.Type -> Base.Type = \(c : Config.Type) ->
  Base.build
    Base.Config::{
      commands = [ fixPermissionsCommand ] # Decorate.decorateAll c.commands,
      label = c.label,
      key = c.key,
      target = Size.Large,
      docker = Docker::{ image = (../Constants/ContainerImages.dhall).codaToolchain },
      summon = Summon::{=}
    }

in {Config = Config, build = build, Type = Base.Type}

