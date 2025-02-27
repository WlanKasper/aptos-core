
<a name="0x1_Reconfiguration"></a>

# Module `0x1::Reconfiguration`

Publishes configuration information for validators, and issues reconfiguration events
to synchronize configuration changes for the validators.


-  [Struct `NewEpochEvent`](#0x1_Reconfiguration_NewEpochEvent)
-  [Resource `Configuration`](#0x1_Reconfiguration_Configuration)
-  [Resource `DisableReconfiguration`](#0x1_Reconfiguration_DisableReconfiguration)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_Reconfiguration_initialize)
-  [Function `disable_reconfiguration`](#0x1_Reconfiguration_disable_reconfiguration)
-  [Function `enable_reconfiguration`](#0x1_Reconfiguration_enable_reconfiguration)
-  [Function `reconfiguration_enabled`](#0x1_Reconfiguration_reconfiguration_enabled)
-  [Function `reconfigure`](#0x1_Reconfiguration_reconfigure)
-  [Function `reconfigure_`](#0x1_Reconfiguration_reconfigure_)
-  [Function `emit_genesis_reconfiguration_event`](#0x1_Reconfiguration_emit_genesis_reconfiguration_event)


<pre><code><b>use</b> <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Event.md#0x1_Event">0x1::Event</a>;
<b>use</b> <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/GUID.md#0x1_GUID">0x1::GUID</a>;
<b>use</b> <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="SystemAddresses.md#0x1_SystemAddresses">0x1::SystemAddresses</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
</code></pre>



<a name="0x1_Reconfiguration_NewEpochEvent"></a>

## Struct `NewEpochEvent`

Event that signals consensus to start a new epoch,
with new configuration information. This is also called a
"reconfiguration event"


<pre><code><b>struct</b> <a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a> <b>has</b> drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>epoch: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x1_Reconfiguration_Configuration"></a>

## Resource `Configuration`

Holds information about state of reconfiguration


<pre><code><b>struct</b> <a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>epoch: u64</code>
</dt>
<dd>
 Epoch number
</dd>
<dt>
<code>last_reconfiguration_time: u64</code>
</dt>
<dd>
 Time of last reconfiguration. Only changes on reconfiguration events.
</dd>
<dt>
<code>events: <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Event.md#0x1_Event_EventHandle">Event::EventHandle</a>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">Reconfiguration::NewEpochEvent</a>&gt;</code>
</dt>
<dd>
 Event handle for reconfiguration events
</dd>
</dl>


</details>

<a name="0x1_Reconfiguration_DisableReconfiguration"></a>

## Resource `DisableReconfiguration`

Reconfiguration disabled if this resource occurs under LibraRoot.


<pre><code><b>struct</b> <a href="Reconfiguration.md#0x1_Reconfiguration_DisableReconfiguration">DisableReconfiguration</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_Reconfiguration_MAX_U64"></a>

The largest possible u64 value


<pre><code><b>const</b> <a href="Reconfiguration.md#0x1_Reconfiguration_MAX_U64">MAX_U64</a>: u64 = 18446744073709551615;
</code></pre>



<a name="0x1_Reconfiguration_ECONFIG"></a>

A <code><a href="Reconfiguration.md#0x1_Reconfiguration">Reconfiguration</a></code> resource is in an invalid state


<pre><code><b>const</b> <a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIG">ECONFIG</a>: u64 = 1;
</code></pre>



<a name="0x1_Reconfiguration_ECONFIGURATION"></a>

The <code><a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a></code> resource is in an invalid state


<pre><code><b>const</b> <a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIGURATION">ECONFIGURATION</a>: u64 = 0;
</code></pre>



<a name="0x1_Reconfiguration_EINVALID_BLOCK_TIME"></a>

An invalid block time was encountered.


<pre><code><b>const</b> <a href="Reconfiguration.md#0x1_Reconfiguration_EINVALID_BLOCK_TIME">EINVALID_BLOCK_TIME</a>: u64 = 3;
</code></pre>



<a name="0x1_Reconfiguration_EINVALID_GUID_FOR_EVENT"></a>

An invalid block time was encountered.


<pre><code><b>const</b> <a href="Reconfiguration.md#0x1_Reconfiguration_EINVALID_GUID_FOR_EVENT">EINVALID_GUID_FOR_EVENT</a>: u64 = 4;
</code></pre>



<a name="0x1_Reconfiguration_EMODIFY_CAPABILITY"></a>

A <code>ModifyConfigCapability</code> is in a different state than was expected


<pre><code><b>const</b> <a href="Reconfiguration.md#0x1_Reconfiguration_EMODIFY_CAPABILITY">EMODIFY_CAPABILITY</a>: u64 = 2;
</code></pre>



<a name="0x1_Reconfiguration_initialize"></a>

## Function `initialize`

Publishes <code><a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a></code> resource. Can only be invoked by core resource account, and only a single time in Genesis.


<pre><code><b>public</b> <b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_initialize">initialize</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_initialize">initialize</a>(
    account: &signer,
) {
    <a href="Timestamp.md#0x1_Timestamp_assert_genesis">Timestamp::assert_genesis</a>();
    <a href="SystemAddresses.md#0x1_SystemAddresses_assert_core_resource">SystemAddresses::assert_core_resource</a>(account);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a>&gt;(@CoreResources), <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIGURATION">ECONFIGURATION</a>));
    // <b>assert</b> it matches `new_epoch_event_key()`, otherwise the event can't be recognized
    <b>assert</b>!(<a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/GUID.md#0x1_GUID_get_next_creation_num">GUID::get_next_creation_num</a>(<a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account)) == 4, <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_EINVALID_GUID_FOR_EVENT">EINVALID_GUID_FOR_EVENT</a>));
    <b>move_to</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a>&gt;(
        account,
        <a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a> {
            epoch: 0,
            last_reconfiguration_time: 0,
            events: <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Event.md#0x1_Event_new_event_handle">Event::new_event_handle</a>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a>&gt;(account),
        }
    );
}
</code></pre>



</details>

<a name="0x1_Reconfiguration_disable_reconfiguration"></a>

## Function `disable_reconfiguration`

Private function to temporarily halt reconfiguration.
This function should only be used for offline WriteSet generation purpose and should never be invoked on chain.


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_disable_reconfiguration">disable_reconfiguration</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_disable_reconfiguration">disable_reconfiguration</a>(account: &signer) {
    <a href="SystemAddresses.md#0x1_SystemAddresses_assert_core_resource">SystemAddresses::assert_core_resource</a>(account);
    <b>assert</b>!(<a href="Reconfiguration.md#0x1_Reconfiguration_reconfiguration_enabled">reconfiguration_enabled</a>(), <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIGURATION">ECONFIGURATION</a>));
    <b>move_to</b>(account, <a href="Reconfiguration.md#0x1_Reconfiguration_DisableReconfiguration">DisableReconfiguration</a> {} )
}
</code></pre>



</details>

<a name="0x1_Reconfiguration_enable_reconfiguration"></a>

## Function `enable_reconfiguration`

Private function to resume reconfiguration.
This function should only be used for offline WriteSet generation purpose and should never be invoked on chain.


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_enable_reconfiguration">enable_reconfiguration</a>(account: &signer)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_enable_reconfiguration">enable_reconfiguration</a>(account: &signer) <b>acquires</b> <a href="Reconfiguration.md#0x1_Reconfiguration_DisableReconfiguration">DisableReconfiguration</a> {
    <a href="SystemAddresses.md#0x1_SystemAddresses_assert_core_resource">SystemAddresses::assert_core_resource</a>(account);

    <b>assert</b>!(!<a href="Reconfiguration.md#0x1_Reconfiguration_reconfiguration_enabled">reconfiguration_enabled</a>(), <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIGURATION">ECONFIGURATION</a>));
    <a href="Reconfiguration.md#0x1_Reconfiguration_DisableReconfiguration">DisableReconfiguration</a> {} = <b>move_from</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_DisableReconfiguration">DisableReconfiguration</a>&gt;(<a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(account));
}
</code></pre>



</details>

<a name="0x1_Reconfiguration_reconfiguration_enabled"></a>

## Function `reconfiguration_enabled`



<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_reconfiguration_enabled">reconfiguration_enabled</a>(): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_reconfiguration_enabled">reconfiguration_enabled</a>(): bool {
    !<b>exists</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_DisableReconfiguration">DisableReconfiguration</a>&gt;(@CoreResources)
}
</code></pre>



</details>

<a name="0x1_Reconfiguration_reconfigure"></a>

## Function `reconfigure`

Signal validators to start using new configuration. Must be called from friend config modules.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_reconfigure">reconfigure</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_reconfigure">reconfigure</a>() <b>acquires</b> <a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a> {
    <a href="Reconfiguration.md#0x1_Reconfiguration_reconfigure_">reconfigure_</a>();
}
</code></pre>



</details>

<a name="0x1_Reconfiguration_reconfigure_"></a>

## Function `reconfigure_`

Private function to do reconfiguration.  Updates reconfiguration status resource
<code><a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a></code> and emits a <code><a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a></code>


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_reconfigure_">reconfigure_</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_reconfigure_">reconfigure_</a>() <b>acquires</b> <a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a> {
    // Do not do anything <b>if</b> genesis <b>has</b> not finished.
    <b>if</b> (<a href="Timestamp.md#0x1_Timestamp_is_genesis">Timestamp::is_genesis</a>() || <a href="Timestamp.md#0x1_Timestamp_now_microseconds">Timestamp::now_microseconds</a>() == 0 || !<a href="Reconfiguration.md#0x1_Reconfiguration_reconfiguration_enabled">reconfiguration_enabled</a>()) {
        <b>return</b> ()
    };

    <b>let</b> config_ref = <b>borrow_global_mut</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a>&gt;(@CoreResources);
    <b>let</b> current_time = <a href="Timestamp.md#0x1_Timestamp_now_microseconds">Timestamp::now_microseconds</a>();

    // Do not do anything <b>if</b> a reconfiguration event is already emitted within this transaction.
    //
    // This is OK because:
    // - The time changes in every non-empty block
    // - A block automatically ends after a transaction that <b>emits</b> a reconfiguration event, which is guaranteed by
    //   VM <b>spec</b> that all transactions comming after a reconfiguration transaction will be returned <b>as</b> Retry
    //   status.
    // - Each transaction must emit at most one reconfiguration event
    //
    // Thus, this check <b>ensures</b> that a transaction that does multiple "reconfiguration required" actions <b>emits</b> only
    // one reconfiguration event.
    //
    <b>if</b> (current_time == config_ref.last_reconfiguration_time) {
        <b>return</b>
    };

    <b>assert</b>!(current_time &gt; config_ref.last_reconfiguration_time, <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_EINVALID_BLOCK_TIME">EINVALID_BLOCK_TIME</a>));
    config_ref.last_reconfiguration_time = current_time;
    config_ref.epoch = config_ref.epoch + 1;

    <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Event.md#0x1_Event_emit_event">Event::emit_event</a>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a>&gt;(
        &<b>mut</b> config_ref.events,
        <a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a> {
            epoch: config_ref.epoch,
        },
    );
}
</code></pre>



</details>

<a name="0x1_Reconfiguration_emit_genesis_reconfiguration_event"></a>

## Function `emit_genesis_reconfiguration_event`

Emit a <code><a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a></code> event. This function will be invoked by genesis directly to generate the very first
reconfiguration event.


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_emit_genesis_reconfiguration_event">emit_genesis_reconfiguration_event</a>()
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="Reconfiguration.md#0x1_Reconfiguration_emit_genesis_reconfiguration_event">emit_genesis_reconfiguration_event</a>() <b>acquires</b> <a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a> {
    <b>assert</b>!(<b>exists</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a>&gt;(@CoreResources), <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_not_published">Errors::not_published</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIGURATION">ECONFIGURATION</a>));
    <b>let</b> config_ref = <b>borrow_global_mut</b>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_Configuration">Configuration</a>&gt;(@CoreResources);
    <b>assert</b>!(config_ref.epoch == 0 && config_ref.last_reconfiguration_time == 0, <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_invalid_state">Errors::invalid_state</a>(<a href="Reconfiguration.md#0x1_Reconfiguration_ECONFIGURATION">ECONFIGURATION</a>));
    config_ref.epoch = 1;

    <a href="../../../../../../../aptos-framework/releases/artifacts/current/build/MoveStdlib/docs/Event.md#0x1_Event_emit_event">Event::emit_event</a>&lt;<a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a>&gt;(
        &<b>mut</b> config_ref.events,
        <a href="Reconfiguration.md#0x1_Reconfiguration_NewEpochEvent">NewEpochEvent</a> {
            epoch: config_ref.epoch,
        },
    );
}
</code></pre>



</details>


[//]: # ("File containing references which can be used from documentation")
[ACCESS_CONTROL]: https://github.com/diem/dip/blob/main/dips/dip-2.md
[ROLE]: https://github.com/diem/dip/blob/main/dips/dip-2.md#roles
[PERMISSION]: https://github.com/diem/dip/blob/main/dips/dip-2.md#permissions
