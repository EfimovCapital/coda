let Prelude = ../../../External/Prelude.dhall
let List/map = Prelude.List.map

let Pipeline = ../../../Pipeline/Dsl.dhall
let Cmd = ../../../Lib/Cmds.dhall
let Command = ../../../Command/Base.dhall
let Size = ../../../Command/Size.dhall
let Docker = ../../../Command/Docker/Type.dhall
let ValidationService = ../../../Projects/ValidationService.dhall

let commands =
  let sigPath = "mix_cache.sig"
  let archivePath = "\"mix-cache-\\\$(sha256sum ${sigPath} | cut -d\" \" -f1).tar.gz\""
  in [
    Cmd.run "${Cmd.format (Cmd.runInDocker ValidationService.docker "elixir --version | tail -n1")} > ${sigPath}",
    Cmd.run "cat ${sigPath}",
    Cmd.run "echo \\\$(pwd)",
    Cmd.run "cat ./buildkite/scripts/cache-through.sh || echo 'does not exist'",
    Cmd.cacheThrough ValidationService.docker archivePath Cmd.CompoundCmd::{
      preprocess = Cmd.run "tar czf ${archivePath} -C ${ValidationService.rootPath} priv/plts",
      postprocess = Cmd.run "tar xzf ${archivePath} -C ${ValidationService.rootPath}",
      inner = ValidationService.runCmd "mix check"
    }
    -- TODO documentation analysis: ValidationService.runMix "doctor"
  ]

in Pipeline.build Pipeline.Config::{
  spec = ./Spec.dhall,
  steps = [
    Command.build Command.Config::{
      commands =
        (List/map
          Cmd.Type
          Cmd.Type
          (Cmd.inDocker ValidationService.docker)
          ValidationService.initCommands) # commands,
      label = "Validation service lint steps; employs various forms static analysis on the elixir codebase",
      key = "lint",
      target = Size.Large,
      docker = None Docker.Type
    }
  ]
}