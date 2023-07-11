import pyteal as pt
from beaker import Application, LocalStateValue
from pathlib import Path

class LocalState:
    struct = LocalStateValue(
        stack_type=pt.TealType.bytes
    )

app = Application(
    "AppAsset", state=LocalState()
)

# LOCAL STATE SUBROUTINES
@pt.Subroutine(pt.TealType.none)
def setLocalState(input: pt.Expr) -> pt.Expr:
    return app.state.struct.set(input)

@pt.Subroutine(pt.TealType.bytes)
def getLocalState() -> pt.Expr:
    return app.state.struct.get()

# ASSET SUBROUTINES
@pt.Subroutine(pt.TealType.uint64)
def asset_create() -> pt.Expr:
    return pt.Seq(
        pt.InnerTxnBuilder.Execute(
            {
                pt.TxnField.fee: pt.Int(0),
                pt.TxnField.type_enum: pt.TxnType.AssetConfig,
                pt.TxnField.config_asset_total: pt.Int(1),
                pt.TxnField.config_asset_decimals: pt.Int(0),
                pt.TxnField.config_asset_default_frozen: pt.Int(1),
                pt.TxnField.config_asset_unit_name: pt.Bytes("foo_struct"),
                pt.TxnField.config_asset_name: pt.Bytes("foo_struct"),
                pt.TxnField.config_asset_manager: pt.Global.current_application_address(),
                pt.TxnField.config_asset_reserve: pt.Global.current_application_address(),
                pt.TxnField.config_asset_freeze: pt.Global.current_application_address(),
                pt.TxnField.config_asset_clawback: pt.Global.current_application_address(),
            }
        ),
        pt.Return(pt.InnerTxn.created_asset_id()),
    )


@app.external
def create_asset(*, output : pt.abi.Uint64) -> pt.Expr:
    x = asset_create()
    return output.set(x)

@app.external
def create_struct(struct_name: pt.abi.String, strucy_field: pt.abi.Uint64, *, output : pt.abi.Uint64) -> pt.Expr:
    x = asset_create()
    return output.set(x)

app_spec = app.build()
output_dir = Path(__file__).parent / "artifacts/" / app_spec.contract.name
print(f"Dumping {app_spec.contract.name} to {output_dir}")
app_spec.export(output_dir)
