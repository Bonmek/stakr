module tid_game::escrow {

    use sui::coin::{Coin,join};
    use sui::sui::SUI;
    use std::option::{none, some, is_none, borrow, extract};

    public struct Owner_cap has key, store { id: UID }

    public struct Tid_game has key, store {
        id: UID,
        owner: ID,
    }

    public struct Escrow has key {
        id: UID,
        challenger_a: Option<address>,
        challenger_b: Option<address>,
        asset: Option<Coin<SUI>>,
    }

    fun init (ctx: &mut TxContext) {
        let owner_cap = Owner_cap {
            id: object::new(ctx),
        };

        transfer::share_object(Tid_game {
            id: object::new(ctx),
            owner: object::id(&owner_cap),
        });

        transfer::transfer(owner_cap, tx_context::sender(ctx));
    }

    public fun create_escrow(ctx: &mut TxContext): Escrow {
        Escrow {
            id: object::new(ctx),
            challenger_a: none(),
            challenger_b: none(),
            asset: none(),
        }
    }

    // public fun add_player(
    //         escrow: &mut Escrow,
    //         coin: Coin<SUI>,
    //         ctx: &mut TxContext
    //     ) {
    //         let player = tx_context::sender(ctx);

    //         if (is_none(&escrow.challenger_a)) {
    //             // Add challenger A
    //             escrow.challenger_a = some(player);
    //             escrow.asset = some<Coin<SUI>>(coin);
    //         } else if (is_none(&escrow.challenger_b)) {
    //             // if A == B -> stop execution
    //             let a = borrow(&escrow.challenger_a);
    //             assert!(*a != player, 0);

    //             // Add challenger B
    //             escrow.challenger_b = some(player);

    //             // merge coin
    //             let old = extract(&mut escrow.asset);
    //             join(&mut coin, old);
    //             option::fill<Coin<SUI>>(&mut escrow.asset, coin);
    //         } else {
    //             // Max player already -> stop execution
    //             assert!(false, 1);
    //         }
    //     }

    // public fun cancel_by_challenger_a(
    //         escrow: Escrow,
    //         ctx: &mut TxContext
    //     ) {
    //         let player = tx_context::sender(ctx);

    //         // Check if sender is challenger_a
    //         assert!(is_some(&escrow.challenger_a), 100); // No challenger_a in escrow -> stop execution
    //         let a = option::extract(&mut escrow.challenger_a);
    //         assert!(a == player, 101); // not challenger_a as a sender -> stop execution

    //         // Check still not have challenger_b in escrow
    //         assert!(is_none(&escrow.challenger_b), 102); // have B in escrow -> stop execution

    //         // pull coin from escrow
    //         let coin = option::extract(&mut escrow.asset);
        
    //         // delete escrow
    //         let Escrow { id, challenger_a: _, challenger_b: _d} = escrow;
    //         object::delete(id);

    //         // send coin back to challenger_a
    //         transfer::public_transfer(coin, tx_context::sender(ctx))
    //     }
}