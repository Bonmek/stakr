// #[test_only]
// module tid_game::tid_game_tests;
//     use tid_game::escrow::{create_owner_cap, create_tid_game, Tid_game};
//     use sui::transfer::public_share_object;
//     use sui::transfer::public_transfer;

// const ENotImplemented: u64 = 0;

// #[test]
// fun test_tid_game() {

//     use sui::test_scenario;

//     let tidgame_admin: address = @0xAAAA;
//     let challenger_a: address = @0x0001;

//     let mut scenario = test_scenario::begin(tidgame_admin);
//     {
//         let owner_cap = create_owner_cap (scenario.ctx());
//         let tid_game = create_tid_game(scenario.ctx(), &owner_cap);

//         transfer::public_share_object(tid_game)
//         transfer::transfer(owner_cap, tx_context::sender(scenario.ctx()));
//     };



//     scenario.end();

    

// }

// #[test, expected_failure(abort_code = ::tid_game::tid_game_tests::ENotImplemented)]
// fun test_tid_game_fail() {
//     abort ENotImplemented
// }
