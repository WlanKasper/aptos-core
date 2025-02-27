import AptosTypes

func demo_peer_to_peer_script() throws {
    let address = AptosTypes.AccountAddress(value: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
    let module = AptosTypes.Identifier(value: "XDX")
    let name = AptosTypes.Identifier(value: "XDX")
    let type_params: [AptosTypes.TypeTag] = []
    let struct_tag = AptosTypes.StructTag(
        address: address,
        module: module,
        name: name,
        type_params: type_params
    )
    let token = AptosTypes.TypeTag.Struct(struct_tag)
    let payee = AptosTypes.AccountAddress(value: [
        0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22,
        0x22,
    ])
    let amount: UInt64 = 1234567
    let script = encode_peer_to_peer_with_metadata_script(
        currency: token,
        payee: payee,
        amount: amount,
        metadata: [],
        metadata_signature: []
    )
    switch try decode_peer_to_peer_with_metadata_script(script: script) {
        case .PeerToPeerWithMetadata(_, let p, let a, _, _):
            assert(p == payee, "Payee doesn't match")
            assert(a == amount, "Amount doesn't match")
        default: assertionFailure("Invalid scriptcall")
    }

    for o in try script.bcsSerialize() {
        print(o, terminator: " ")
    }
    print()
}

func demo_peer_to_peer_script_function() throws {
    let address = AptosTypes.AccountAddress(value: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1])
    let module = AptosTypes.Identifier(value: "XDX")
    let name = AptosTypes.Identifier(value: "XDX")
    let type_params: [AptosTypes.TypeTag] = []
    let struct_tag = AptosTypes.StructTag(
        address: address,
        module: module,
        name: name,
        type_params: type_params
    )
    let token = AptosTypes.TypeTag.Struct(struct_tag)
    let payee = AptosTypes.AccountAddress(value: [
        0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22,
        0x22,
    ])
    let amount: UInt64 = 1234567
    let script = try PaymentScripts.encode_peer_to_peer_with_metadata_script_function(
        currency: token,
        payee: payee,
        amount: amount,
        metadata: [],
        metadata_signature: []
    )
    switch try PaymentScripts.decode_peer_to_peer_with_metadata_script_function(payload: script) {
        case .PeerToPeerWithMetadata(_, let p, let a, _, _):
            assert(p == payee, "Payee doesn't match")
            assert(a == amount, "Amount doesn't match")
        default: assertionFailure("Invalid script function call")
    }

    for o in try script.bcsSerialize() {
        print(o, terminator: " ")
    }
    print()
}

try demo_peer_to_peer_script()
try demo_peer_to_peer_script_function()
