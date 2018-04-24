open Core_kernel
open Async_kernel
open Nanobit_base

module Make_prod (Init : sig val prover : Prover.t end) = struct
  type t = Proof.t
  type input =
    { source     : Ledger_hash.t
    ; target     : Ledger_hash.t
    ; proof_type : Transaction_snark.Proof_type.t
    }

  let verify proof { source; target; proof_type } =
    Prover.verify_transaction_snark Init.prover
      (Transaction_snark.create ~source ~target ~proof_type ~proof)
    >>| Or_error.ok_exn
end

module Debug = struct
  type t = ()
  type input = ()
  let verify _ _ = return true
end

