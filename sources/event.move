module hamsterpocket::event {
    use std::string::String;

    use aptos_framework::event;
    use aptos_framework::account;
    use aptos_framework::timestamp;

    use hamsterpocket::pocket::Pocket;

    friend hamsterpocket::chef;

    const HAMSTERPOCKET: address = @hamsterpocket;

    struct UpdateOperatorEvent has store, drop, copy {
        actor: address,
        target: address,
        value: bool,
        timestamp: u64
    }

    struct UpdateTargetEvent has store, drop, copy {
        actor: address,
        target: address,
        value: bool,
        timestamp: u64
    }

    // define update trading stats event
    struct UpdatePocketStatusEvent has store, drop, copy {
        id: String,
        actor: address,
        status: u64,
        reason: String,
        timestamp: u64
    }

    // define update trading stats event
    struct UpdatePocketEvent has store, drop, copy {
        id: String,
        actor: address,
        pocket: Pocket,
        reason: String,
        timestamp: u64
    }

    // define update pocket deposit event
    struct UpdateDepositStatsEvent has store, drop, copy {
        id: String,
        actor: address,
        amount: u64,
        token_address: address,
        reason: String,
        timestamp: u64
    }

    // define udpate withdrawal stats event
    struct UpdateWithdrawalStatsEvent has store, drop, copy {
        id: String,
        actor: address,
        base_token_amount: u64,
        base_token_address: address,
        target_token_amount: u64,
        target_token_address: address,
        reason: String,
        timestamp: u64
    }

    // define update trading stats event
    struct UpdateTradingStatsEvent has store, drop, copy {
        id: String,
        actor: address,
        swapped_base_token_amount: u64,
        base_token_address: address,
        received_target_token_amount: u64,
        target_token_address: address,
        reason: String,
        timestamp: u64
    }

    // define update close position event
    struct UpdateClosePositionEvent has store, drop, copy {
        id: String,
        actor: address,
        swapped_target_token_amount: u64,
        target_token_address: address,
        received_base_token_amount: u64,
        base_token_address: address,
        reason: String,
        timestamp: u64
    }

    struct EventManager has key {
        update_allowed_target: event::EventHandle<UpdateTargetEvent>,
        update_allowed_operator: event::EventHandle<UpdateOperatorEvent>,
        create_pocket: event::EventHandle<UpdatePocketEvent>,
        update_pocket: event::EventHandle<UpdatePocketEvent>,
        update_pocket_status: event::EventHandle<UpdatePocketStatusEvent>,
        update_trading_stats: event::EventHandle<UpdateTradingStatsEvent>,
        update_close_position: event::EventHandle<UpdateClosePositionEvent>,
        update_deposit_stats: event::EventHandle<UpdateDepositStatsEvent>,
        update_withdrawal_stats: event::EventHandle<UpdateWithdrawalStatsEvent>
    }

    // initialize module
    public(friend) fun initialize(hamsterpocket_signer: &signer) {
        move_to(
            hamsterpocket_signer,
            EventManager {
                update_allowed_target: account::new_event_handle<UpdateTargetEvent>(hamsterpocket_signer),
                update_allowed_operator: account::new_event_handle<UpdateOperatorEvent>(hamsterpocket_signer),
                create_pocket: account::new_event_handle<UpdatePocketEvent>(hamsterpocket_signer),
                update_pocket: account::new_event_handle<UpdatePocketEvent>(hamsterpocket_signer),
                update_pocket_status: account::new_event_handle<UpdatePocketStatusEvent>(hamsterpocket_signer),
                update_trading_stats: account::new_event_handle<UpdateTradingStatsEvent>(hamsterpocket_signer),
                update_close_position: account::new_event_handle<UpdateClosePositionEvent>(hamsterpocket_signer),
                update_deposit_stats: account::new_event_handle<UpdateDepositStatsEvent>(hamsterpocket_signer),
                update_withdrawal_stats: account::new_event_handle<UpdateWithdrawalStatsEvent>(hamsterpocket_signer)
            }
        );
    }

    // emit update allowed target event
    public(friend) fun emit_update_allowed_target_event(
        actor: address,
        target: address,
        value: bool
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdateTargetEvent>(
            &mut event_manager.update_allowed_target,
            UpdateTargetEvent {
                actor,
                target,
                value,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update allowed target event
    public(friend) fun emit_update_allowed_operator_event(
        actor: address,
        target: address,
        value: bool
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdateOperatorEvent>(
            &mut event_manager.update_allowed_operator,
            UpdateOperatorEvent {
                actor,
                target,
                value,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit create pocket event
    public(friend) fun emit_create_pocket_event(
        id: String,
        actor: address,
        pocket: Pocket,
        reason: String
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdatePocketEvent>(
            &mut event_manager.create_pocket,
            UpdatePocketEvent {
                id,
                actor,
                pocket,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update pocket event
    public(friend) fun emit_update_pocket_event(
        id: String,
        actor: address,
        pocket: Pocket,
        reason: String
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdatePocketEvent>(
            &mut event_manager.update_pocket,
            UpdatePocketEvent {
                id,
                actor,
                pocket,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update pocket status event
    public(friend) fun emit_update_pocket_status_event(
        id: String,
        actor: address,
        status: u64,
        reason: String,
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdatePocketStatusEvent>(
            &mut event_manager.update_pocket_status,
            UpdatePocketStatusEvent {
                id,
                actor,
                status,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update deposit status event
    public(friend) fun emit_update_deposit_stats_event(
        id: String,
        actor: address,
        amount: u64,
        token_address: address,
        reason: String
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdateDepositStatsEvent>(
            &mut event_manager.update_deposit_stats,
            UpdateDepositStatsEvent {
                id,
                actor,
                amount,
                token_address,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update withdrawal status event
    public(friend) fun emit_update_withdrawal_stats_event(
        id: String,
        actor: address,
        base_token_amount: u64,
        base_token_address: address,
        target_token_amount: u64,
        target_token_address: address,
        reason: String,
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdateWithdrawalStatsEvent>(
            &mut event_manager.update_withdrawal_stats,
            UpdateWithdrawalStatsEvent {
                id,
                actor,
                base_token_amount,
                base_token_address,
                target_token_amount,
                target_token_address,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update trading status event
    public(friend) fun emit_update_trading_stats_event(
        id: String,
        actor: address,
        swapped_base_token_amount: u64,
        base_token_address: address,
        received_target_token_amount: u64,
        target_token_address: address,
        reason: String,
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdateTradingStatsEvent>(
            &mut event_manager.update_trading_stats,
            UpdateTradingStatsEvent {
                id,
                actor,
                swapped_base_token_amount,
                base_token_address,
                received_target_token_amount,
                target_token_address,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }

    // emit update closing position status event
    public(friend) fun emit_update_close_position_stats(
        id: String,
        actor: address,
        swapped_target_token_amount: u64,
        target_token_address: address,
        received_base_token_amount: u64,
        base_token_address: address,
        reason: String,
    ) acquires EventManager {
        let event_manager = borrow_global_mut<EventManager>(HAMSTERPOCKET);

        event::emit_event<UpdateClosePositionEvent>(
            &mut event_manager.update_close_position,
            UpdateClosePositionEvent {
                id,
                actor,
                swapped_target_token_amount,
                base_token_address,
                received_base_token_amount,
                target_token_address,
                reason,
                timestamp: timestamp::now_seconds()
            }
        );
    }
}