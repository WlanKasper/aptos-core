
<a name="0x1_ChainId"></a>

# Module `0x1::ChainId`

The chain id distinguishes between different chains (e.g., testnet and the main Diem network).
One important role is to prevent transactions intended for one chain from being executed on another.
This code provides a container for storing a chain id and functions to initialize and get it.


-  [Resource `ChainId`](#0x1_ChainId_ChainId)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0x1_ChainId_initialize)
-  [Function `get`](#0x1_ChainId_get)
-  [Module Specification](#@Module_Specification_1)
    -  [Initialization](#@Initialization_2)
    -  [Helper Functions](#@Helper_Functions_3)


<pre><code><b>use</b> <a href="CoreAddresses.md#0x1_CoreAddresses">0x1::CoreAddresses</a>;
<b>use</b> <a href="../../../../../../../DPN/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors">0x1::Errors</a>;
<b>use</b> <a href="../../../../../../../DPN/releases/artifacts/current/build/MoveStdlib/docs/Signer.md#0x1_Signer">0x1::Signer</a>;
<b>use</b> <a href="Timestamp.md#0x1_Timestamp">0x1::Timestamp</a>;
</code></pre>



<a name="0x1_ChainId_ChainId"></a>

## Resource `ChainId`



<pre><code><b>struct</b> <a href="ChainId.md#0x1_ChainId">ChainId</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x1_ChainId_ECHAIN_ID"></a>

The <code><a href="ChainId.md#0x1_ChainId">ChainId</a></code> resource was not in the required state


<pre><code><b>const</b> <a href="ChainId.md#0x1_ChainId_ECHAIN_ID">ECHAIN_ID</a>: u64 = 0;
</code></pre>



<a name="0x1_ChainId_initialize"></a>

## Function `initialize`

Publish the chain ID <code>id</code> of this Diem instance under the DiemRoot account


<pre><code><b>public</b> <b>fun</b> <a href="ChainId.md#0x1_ChainId_initialize">initialize</a>(dr_account: &signer, id: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ChainId.md#0x1_ChainId_initialize">initialize</a>(dr_account: &signer, id: u8) {
    <a href="Timestamp.md#0x1_Timestamp_assert_genesis">Timestamp::assert_genesis</a>();
    <a href="CoreAddresses.md#0x1_CoreAddresses_assert_diem_root">CoreAddresses::assert_diem_root</a>(dr_account);
    <b>assert</b>!(!<b>exists</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(<a href="../../../../../../../DPN/releases/artifacts/current/build/MoveStdlib/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(dr_account)), <a href="../../../../../../../DPN/releases/artifacts/current/build/MoveStdlib/docs/Errors.md#0x1_Errors_already_published">Errors::already_published</a>(<a href="ChainId.md#0x1_ChainId_ECHAIN_ID">ECHAIN_ID</a>));
    <b>move_to</b>(dr_account, <a href="ChainId.md#0x1_ChainId">ChainId</a> { id })
}
</code></pre>



</details>

<details>
<summary>Specification</summary>



<pre><code><b>pragma</b> opaque;
<b>let</b> dr_addr = <a href="../../../../../../../DPN/releases/artifacts/current/build/MoveStdlib/docs/Signer.md#0x1_Signer_address_of">Signer::address_of</a>(dr_account);
<b>modifies</b> <b>global</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(dr_addr);
<b>include</b> <a href="Timestamp.md#0x1_Timestamp_AbortsIfNotGenesis">Timestamp::AbortsIfNotGenesis</a>;
<b>include</b> <a href="CoreAddresses.md#0x1_CoreAddresses_AbortsIfNotDiemRoot">CoreAddresses::AbortsIfNotDiemRoot</a>{account: dr_account};
<b>aborts_if</b> <b>exists</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(dr_addr) <b>with</b> Errors::ALREADY_PUBLISHED;
<b>ensures</b> <b>exists</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(dr_addr);
</code></pre>



</details>

<a name="0x1_ChainId_get"></a>

## Function `get`

Return the chain ID of this Diem instance


<pre><code><b>public</b> <b>fun</b> <a href="ChainId.md#0x1_ChainId_get">get</a>(): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="ChainId.md#0x1_ChainId_get">get</a>(): u8 <b>acquires</b> <a href="ChainId.md#0x1_ChainId">ChainId</a> {
    <a href="Timestamp.md#0x1_Timestamp_assert_operating">Timestamp::assert_operating</a>();
    <b>borrow_global</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(@DiemRoot).id
}
</code></pre>



</details>

<a name="@Module_Specification_1"></a>

## Module Specification



<a name="@Initialization_2"></a>

### Initialization


When Diem is operating, the chain id is always available.


<pre><code><b>invariant</b> [suspendable] <a href="Timestamp.md#0x1_Timestamp_is_operating">Timestamp::is_operating</a>() ==&gt; <b>exists</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(@DiemRoot);
</code></pre>



<a name="@Helper_Functions_3"></a>

### Helper Functions



<a name="0x1_ChainId_spec_get_chain_id"></a>


<pre><code><b>fun</b> <a href="ChainId.md#0x1_ChainId_spec_get_chain_id">spec_get_chain_id</a>(): u8 {
   <b>global</b>&lt;<a href="ChainId.md#0x1_ChainId">ChainId</a>&gt;(@DiemRoot).id
}
</code></pre>
