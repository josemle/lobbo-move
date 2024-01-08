import pyteal as pt
from beaker import Application, LocalStateValue

class S:
    val = LocalStateValue(
        stack_type=pt.TealType.uint64,
    )

app = Application(
    "S", state=S()
)

@app.external
def set(new_val: pt.abi.Uint64) -> pt.Expr:
    return app.state.val.set(new_val.get())


@app.external
def get(*, output: pt.abi.Uint64) -> pt.Expr:
    return output.set(app.state.val.get())

@app.external
def update(new_val: pt.abi.Uint64) -> pt.Expr:
    return app.state.val.set(new_val.get())


app_spec = app.build()
output_dir = Path(__file__).parent / "artifacts/" / app_spec.contract.name
print(f"Dumping {app_spec.contract.name} to {output_dir}")
app_spec.export(output_dir)
